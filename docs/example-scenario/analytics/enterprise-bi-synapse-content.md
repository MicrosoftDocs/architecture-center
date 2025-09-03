This article describes how to transfer data from an on-premises data warehouse to a cloud environment and then use a business intelligence (BI) model to serve the data. You can use this approach as an end goal or a first step toward full modernization with cloud-based components.

This guidance builds on the [Azure Synapse Analytics end-to-end scenario][e2e-analytics]. This process has multiple options to extract data from on-premises SQL Server. Then it performs data transformation for analysis. 

- Microsoft Fabric Data Factory pipelines to ingest data in a metadata driven framework from a SQL database into Fabric Lakehouse/Warehouse. This batch method of extraction should be preferred for maximum flexibility in the ingestion process

- Microsoft Fabric Mirroring/COPY Job for SQL Server to ingest data in a low-code GUI based process for full and incremental loads. This is a cost effective managed process for continous ingestion of data into OneLake via Mirroring or highly scalable ingeston through COPY JOB.

- Microsoft Fabric Real Time Intelligence Eventsteams for real time event driven ingestion framework for SQL Server CDC source processes.

## When to use this architecture

You can use various methods to meet business requirements for enterprise BI. Various aspects define business requirements, such as current technology investments, human skills, the timeline for modernization, future goals, and whether you have a preference for platform as a service (PaaS) or software as a service (SaaS). 

Consider the following design approaches:

- [A lakehouse in Microsoft Fabric](/azure/architecture/example-scenario/data/greenfield-lakehouse-fabric)

- [Fabric and Azure Databricks](/azure/architecture/solution-ideas/articles/small-medium-modern-data-platform) for customers that have existing investment in Azure Databricks and Power BI and want to modernize with Fabric 
- Enterprise BI for small and medium businesses that use an [Azure SQL ecosystem and Fabric](/azure/architecture/example-scenario/data/small-medium-data-warehouse)
- Data warehousing completely on Fabric for customers that prefer SaaS

The architecture in this article assumes that you use Microsoft Fabric data Lakehouse/Warehouse as the persistent layer of the enterprise semantic model and you use Power BI for business intelligence. This SaaS approach has the flexibility to accommodate various business requirements and preferences.

## Architecture

:::image type="complex" source="./media/enterprise-bi-scoped-architecture.svg" border="false" lightbox="./media/enterprise-bi-scoped-architecture.svg" alt-text="Diagram that shows the enterprise BI architecture with Azure Synapse Analytics.":::
The diagram shows types of input, like data streams, databases, data services, unstructured data, and structured data. Components in the Ingest phase receive the data input. The Ingest phase components are Azure Event Hubs, Azure IoT Hub, Azure Synapse Analytics, and pipelines. Azure Synapse Analytics is also in the Store phase and the Process phase. The next step in the dataflow is the Store phase, which contains Azure Data Lake Storage. Then the data goes to the Process phase, which contains Azure Stream Analytics, Azure Data Explorer pools, Apache Spark pools, and serverless and dedicated SQL pools. Some of the machine learning model data goes to the Enrich phase, which contains Azure AI services and Azure Machine Learning. The other data goes to the Serve phase, which contains Power BI premium, Azure Cosmos DB, Azure AI Search, and Azure Data Share. The data outputs to business users, analytics, applications, and shared datasets.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/enterprise-bi-scoped-architecture.vsdx) of this architecture.*

### Workflow

#### Data source

- A SQL Server database in Azure contains the source data. To simulate the on-premises environment, deployment scripts for this scenario configure an Azure SQL database. The [AdventureWorks sample database][adventureworksdw-sample-link] is used as the source data schema and sample data. For more information, see [Copy and transform data to and from SQL Server](/azure/data-factory/connector-sql-server).

#### Ingestion and data storage

- [Microsoft Fabric OneLake](/fabric/onelake/onelake-overview) is single, unified, logical data lake for your whole organization. This SaaS offers various data storage option such as a [Fabric Lakehouse](/fabric/data-engineering/lakehouse-overview) for data engineering lakehouse workloads, [Fabric Warehouse](/fabric/data-warehouse/data-warehousing) for data warehouse workloads, and [Fabric Eventhouse](/fabric/real-time-intelligence/eventhouse) for high volume time series and log datasets.

- [Microsoft Fabric Data Factory Pipelines](/fabric/data-factory/data-factory-overview#data-pipelines) to build complex ETL and data factory workflows that can perform many different tasks at scale. Control flow capabilities are built into data pipelines that allow you to build workflow logic, which provides loops and conditionals. Here, metadata driven frameworks are used for incremental ingestion for multiple tables at scale.

- [Microsoft Fabric Data Factory Mirroing](/fabric/mirroring/sql-server) provides an easy experience to avoid complex ETL (Extract Transform Load) and integrate your existing SQL Server estate with the rest of your data in Microsoft Fabric. You can continuously replicate your existing SQL Server databases directly into Fabric's OneLake. [Microsoft Fabric Data Factory COPY Job](/fabric/data-factory/what-is-copy-job) makes it easy to move data from your source to your destination--no pipelines required. With a simple, guided experience, you can set up data transfers using built-in patterns for both batch and incremental copy with very highly scalable performance. 

- [Microsoft Fabric Eventstreams](/fabric/real-time-intelligence/event-streams/add-source-sql-server-change-data-capture) offers high throught-put real time data ingestion from a SQL Server database on VM using CDC extraction. This pattern is suitable for usecases that needs real time dashboards and alerting.




#### Analysis and reporting

- The data-modeling approach in this scenario combines the [enterprise model][enterprise-model] and the [BI semantic model][bi-model]. Fabric FSKUs will provide the compute for Power BI semantic models as explained in [Power BI Premium capacity F64](/fabric/enterprise/powerbi/service-premium-what-is#capacities-and-skus). Power BI acan access the data via Import, DirectQuery or DirectLake connectivity.

### Components

This scenario uses the following components:

- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) is an Azure-hosted PaaS SQL server. This architecture uses SQL Database to demonstrate the flow of data for the migration scenario. 

- [Fabric OneLake Storage](/fabric/onelake/onelake-overview) provides unified cloud storage for all structured & unstructured data for the whole organization.
- [Fabric DataWarehouse](/fabric/data-warehouse/data-warehousing) is a SaaS offering to host data warehouse workloads for large datasets.
- [Power BI Premium](/power-bi/enterprise/service-premium-what-is) is a BI tool hosted on Fabric compute that presents and visualizes data in this scenario.
- [Microsoft Entra ID](/entra/fundamentals/whatis) is a multicloud identity and network solution suite that supports the authentication and authorization flow.

### Simplified architecture

:::image type="complex" source="./media/enterprise-bi-small-architecture.png" border="false" lightbox="./media/enterprise-bi-small-architecture.png" alt-text="Diagram that shows the enterprise BI simplified architecture.":::
The diagram shows a dataflow where Azure Synapse Analytics pipelines ingest relational databases. Azure Synapse Analytics dedicated SQL pools store the data. Power BI Premium serves the data. The data outputs to business users and analytics.
:::image-end:::

## Scenario details

In this scenario, an organization has a SQL database that contains a large on-premises data warehouse. The organization wants to use Microsoft Fabric to perform ingestion, analysis, and deliver these analytic insights via Power BI to end users.

### Authentication

Microsoft Entra ID authenticates users who connect to Power BI dashboards and apps. Single sign-on connects users to the data in Fabric Warehouse & Power BI semantic model. Authorization occurs on the source.

### Incremental loading

When you run an automated extract, transform, load (ETL) or extract, load, transform (ELT) process, you should load only the data that changed since the previous run. This process is called an [incremental load](/fabric/data-factory/tutorial-incremental-copy-data-warehouse-lakehouse). Conversely, a full load loads all the data. To perform an incremental load, determine how to identify the changed data. You can use a *high water mark* value approach, which tracks the latest value of a date-time column or a unique integer column in the source table.

You can use [temporal tables](/sql/relational-databases/tables/temporal-tables) in SQL Server. Temporal tables are system-versioned tables that store data change history. The database engine automatically records the history of every change in a separate history table. To query the historical data, you can add a `FOR SYSTEM_TIME` clause to a query. Internally, the database engine queries the history table, but it's transparent to the application.

Temporal tables support dimension data, which can change over time. Fact tables usually represent an immutable transaction such as a sale, in which case keeping the system version history doesn't make sense. Instead, transactions usually have a column that represents the transaction date. The column can be used as the watermark value. For example, in the AdventureWorks data warehouse, the `SalesLT.*` tables have a `LastModified` field.

Here's the general flow for the ELT pipeline:

1. For each table in the source database, track the cutoff time when the last ELT job ran. Store this information in the data warehouse. On initial setup, all times are set to `1-1-1900`.

2. During the data export step, the cutoff time is passed as a parameter to a set of stored procedures in the source database. These stored procedures query any records that are changed or created after the cutoff time. For all tables in the example, you can use the `ModifiedDate` column.

3. When the data migration is complete, update the table that stores the cutoff times.

## Data pipeline

This scenario uses the [AdventureWorks sample database][adventureworksdw-sample-link] as a data source. The incremental data load pattern ensures that only data that's modified or added after the most recent pipeline run is loaded.

### Metadata-driven ingestion framework

The [metadata-driven ingestion framework](/fabric/data-factory/tutorial-incremental-copy-data-warehouse-lakehouse) within Fabric Data Factory pipelines incrementally loads all tables that are contained in the relational database. While the article refers to a data warehouse as a source, it can be replaced with an Azure SQL DB as source.

1. Pick a watermark column. Choose one column in your source table that helps track new or changed records. This column usually contains values that increase when rows are added or updated (like a timestamp or ID). We'll use the highest value in this column as our "watermark" to know where we left off.

1. Set up a table to store your last watermark value.

1. Build a pipeline that does the following:

     The pipeline includes these activities:

      -  Two lookup activities. The first one gets the last watermark value (where we stopped last time). The second one gets the new watermark value (where  we'll stop this time). Both values get passed to the copy activity.
      - A copy activity that finds rows where the watermark column value is between the old and new watermarks. It then copies this data from your Data Warehouse to your Lakehouse as a new file.
      - A stored procedure activity that saves the new watermark value so the next pipeline run knows where to start.

:::image type="content" source="./media/metadata-copy.png" alt-text="Screenshot that shows the metadata-driven Copy Data tool in Azure Synapse Analytics." lightbox="./media/metadata-copy.png":::

Before the tool loads the data, it creates three pipelines to iterate over the tables in the database.

The pipelines do the following tasks:

- Count the number of objects, such as tables, to be copied in the pipeline run.

- Iterate over each object to be loaded or copied.
- After a pipeline iterates over each object, it does the following tasks:
  - Checks whether a delta load is required. Otherwise, the pipeline completes a normal full load.

  - Retrieves the high watermark value from the control table.
  - Copies data from the source tables into the staging account in Data Lake Storage.
  - Loads data into the dedicated SQL pool via the selected copy method, such as the PolyBase or Copy command.
  - Updates the high watermark value in the control table.

### Load data into an Azure Synapse Analytics SQL pool

The [copy activity](/azure/data-factory/copy-activity-overview) copies data from the SQL database into the Azure Synapse Analytics SQL pool. This example's SQL database is in Azure, so it uses the Azure integration runtime to read data from the SQL database and write the data into the specified staging environment.

The copy statement then loads data from the staging environment into the Azure Synapse Analytics dedicated pool.

### Use Azure Synapse Analytics pipelines

Pipelines in Azure Synapse Analytics define an ordered set of activities to complete an incremental load pattern. Manual or automatic triggers start the pipeline.

### Transform the data

The sample database in this reference architecture is small, so replicated tables that have no partitions are created. For production workloads, distributed tables can improve query performance. For more information, see [Guidance for designing distributed tables in Azure Synapse Analytics](/azure/sql-data-warehouse/sql-data-warehouse-tables-distribute). The example scripts run the queries via a static [resource class](/azure/sql-data-warehouse/resource-classes-for-workload-management).

In a production environment, consider creating staging tables that have round-robin distribution. Then transform and move the data into production tables that have clustered columnstore indexes, which offer the best overall query performance. Columnstore indexes are optimized for queries that scan many records.

Columnstore indexes don't perform optimally for singleton lookups, or looking up a single row. If you need to perform frequent singleton lookups, you can add a nonclustered index to a table, which increases speed. However, singleton lookups are typically less common in data warehouse scenarios than online transaction processing workloads. For more information, see [Index tables in Azure Synapse Analytics](/azure/sql-data-warehouse/sql-data-warehouse-tables-index).

> [!NOTE]
> Clustered columnstore tables don't support `varchar(max)`, `nvarchar(max)`, or `varbinary(max)` data types. If you use those data types, consider a heap or clustered index. You might also consider putting these columns into a separate table.

### Use Power BI Premium to access, model, and visualize data

Power BI Premium supports several options to connect to data sources on Azure. You can use Azure Synapse Analytics provisioned pools to do the following tasks:

- Import: The data is imported into the Power BI model.
- [DirectQuery](/power-bi/connect-data/desktop-directquery-about): Data is pulled directly from relational storage.
- [Composite model](/power-bi/transform-model/desktop-composite-models): Combine *Import* for some tables and *DirectQuery* for others.

This scenario uses the DirectQuery dashboard because it has a small amount of data and low model complexity. DirectQuery delegates the query to the underlying compute engine and uses security capabilities on the source. DirectQuery ensures that results are always consistent with the latest source data.

Import mode can provide the lowest query latency. Consider import mode if:

- The model fits entirely within the memory of Power BI.
- The data latency between refreshes is acceptable.
- You require complex transformations between the source system and the final model.

In this case, the end users want full access to the most recent data with no delays in Power BI refreshing, and they want all historical data, which exceeds the Power BI dataset capacity. A Power BI dataset can handle 25-400 GB, depending on the capacity size. The data model in the dedicated SQL pool is already in a star schema and doesn't require transformation, so DirectQuery is an appropriate choice.

:::image type="content" source="./media/adventure-works-dashboard.png" alt-text="Screenshot that shows the dashboard in Power BI." lightbox="./media/adventure-works-dashboard.png":::

Use [Power BI Premium](/power-bi/enterprise/service-premium-gen2-what-is) to manage large models, paginated reports, and deployment pipelines. Take advantage of the built-in Azure Analysis Services endpoint. You can also have dedicated [capacity](/power-bi/admin/service-premium-what-is#capacities-and-skus) with unique value proposition.

When the BI model grows or dashboard complexity increases, you can switch to composite models and import parts of lookup tables via [hybrid tables](/power-bi/connect-data/service-dataset-modes-understand#hybrid-tables), and import preaggregated data. You can enable [query caching](/power-bi/connect-data/power-bi-query-caching) within Power BI for imported datasets and use [dual tables](/power-bi/transform-model/desktop-storage-mode) for the storage mode property.

Within the composite model, datasets serve as a virtual pass-through layer. When users interact with visualizations, Power BI generates SQL queries to Azure Synapse Analytics SQL pools. Power BI determines whether to use in-memory or DirectQuery storage based on efficiency. The engine decides when to switch from in-memory to DirectQuery and pushes the logic to the Azure Synapse Analytics SQL pool. Depending on the context of the query tables, they can act as either cached (imported) or non-cached composite models. You can choose which table to cache into memory, combine data from one or more DirectQuery sources, or combine DirectQuery source data and imported data.

When you use DirectQuery with an Azure Synapse Analytics provisioned pool:

- Use Azure Synapse Analytics [result set caching](/azure/synapse-analytics/sql-data-warehouse/performance-tuning-result-set-caching) to cache query results in the user database for repetitive use. This approach improves query performance to milliseconds and reduces compute resource usage. Queries that use cached results sets don't consume any concurrency slots in Azure Synapse Analytics, so they don't count against existing concurrency limits.

- Use Azure Synapse Analytics [materialized views](/azure/synapse-analytics/sql/develop-materialized-view-performance-tuning) to precompute, store, and maintain data like a table. Queries that use all data or a subset of the data in materialized views can achieve faster performance without needing to directly reference the defined materialized view to use it.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Cloud modernization introduces security concerns, such as data breaches, malware infections, and malicious code injection. You need a cloud provider or service solution that can address your concerns because inadequate security measures can create major problems.

This scenario addresses the most demanding security concerns by using a combination of layered security controls: network, identity, privacy, and authorization controls. An Azure Synapse Analytics provisioned pool stores most of the data. Power BI accesses the data via DirectQuery through single sign-on. You can use Microsoft Entra ID for authentication. There are also extensive security controls for data authorization within the provisioned pools.

Some common security questions include:

- Define who can see what data.
  - Ensure that your data complies with federal, local, and company guidelines to mitigate data breach risks. Azure Synapse Analytics provides multiple [data protection capabilities](/azure/synapse-analytics/guidance/security-white-paper-data-protection) to achieve compliance.

- Determine how to verify a user's identity.
  - Use Azure Synapse Analytics to control who can access what data via [access control](/azure/synapse-analytics/guidance/security-white-paper-access-control) and [authentication](/azure/synapse-analytics/guidance/security-white-paper-authentication).
- Choose a network security technology to protect the integrity, confidentiality, and access of your networks and data.
  - Help secure Azure Synapse Analytics by using [network security](/azure/synapse-analytics/guidance/security-white-paper-network-security) options.
- Choose tools to detect and notify you of threats.
  - Use Azure Synapse Analytics [threat detection](/azure/synapse-analytics/guidance/security-white-paper-threat-protection) capabilities, such as SQL auditing, SQL threat detection, and vulnerability assessment to audit, protect, and monitor databases.
- Determine how to protect data in your storage account.
  - Use Azure Storage accounts for workloads that require fast and consistent response times or that have a high number of input/output operations (IOPs) per second. Storage accounts can store all your data objects and have several [storage account security options](/azure/well-architected/service-guides/azure-blob-storage#security).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

This section provides information about pricing for different services involved in this solution, and mentions decisions made for this scenario with a sample dataset. Use this starting configuration in the [Azure pricing calculator](https://azure.com/e/598c407dc58545e090c8cfd6c7dbc190), and adjust it to fit your scenario.

#### Azure Synapse Analytics

Azure Synapse Analytics is a serverless architecture that you can use to scale your compute and storage levels independently. Compute resources incur costs based on usage. You can scale or pause these resources on demand. Storage resources incur costs per terabyte, so your costs increase as you ingest data.

#### Azure Synapse Analytics pipelines

Three main components influence the price of a pipeline:

- Data pipeline activities and integration runtime hours
- Data flows cluster size and implementation
- Operation charges

For pricing details, see the *Data Integration* tab on [Azure Synapse Analytics pricing](https://azure.microsoft.com/pricing/details/synapse-analytics). 

The price varies depending on components or activities, frequency, and the number of integration runtime units.

For the sample dataset, which uses the standard Azure-hosted integration runtime, *copy data activity* serves as the core of the pipeline. It runs on a daily schedule for all the entities (tables) in the source database. The scenario doesn't contain data flows. And it doesn't incur operational costs because the pipelines run less than one million operations per month.

#### Azure Synapse Analytics dedicated pool and storage

For the sample dataset, you can provision 500 data warehouse units (DWUs) to provide a smooth experience for analytical loads. You can maintain compute during business hours for reporting purposes. If the solution moves to production, use reserved data warehouse capacity as a cost-efficient strategy. Use various techniques to maximize cost and performance metrics.

For pricing details for an Azure Synapse Analytics dedicated pool, see the *Data Warehousing* tab on [Azure Synapse Analytics pricing](https://azure.microsoft.com/pricing/details/synapse-analytics). Under the dedicated consumption model, customers incur costs for each provisioned DWU, per hour of uptime. Also consider data storage costs, including the size of your data at rest, snapshots, and geo-redundancy.

#### Blob storage

Consider using the Azure Storage reserved capacity to reduce storage costs. With this model, you get a discount if you reserve fixed storage capacity for one or three years. For more information, see [Optimize costs for blob storage with reserved capacity][az-storage-reserved]. This scenario doesn't use persistent storage.

#### Power BI Premium

This scenario uses [Power BI Premium workspaces](/power-bi/admin/service-premium-what-is) with built-in performance enhancements to accommodate demanding analytical needs.

For more information, see [Power BI pricing](https://powerbi.microsoft.com/pricing).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- Use an Azure DevOps release pipeline and GitHub Actions to automate the deployment of an Azure Synapse Analytics workspace across multiple environments. For more information, see [Continuous integration and continuous delivery for an Azure Synapse Analytics workspace](/azure/synapse-analytics/cicd/continuous-integration-delivery).
- Put each workload in a separate deployment template, and store the resources in source control systems. You can deploy the templates together or individually as part of a continuous integration and continuous delivery (CI/CD) process. This approach simplifies the automation process. This architecture has four main workloads:
  - The data warehouse server and related resources
  - Azure Synapse Analytics pipelines
  - Power BI assets, including dashboards, apps, and datasets
  - An on-premises to cloud simulated scenario

- Consider staging your workloads where practical. Deploy your workload to various stages. Run validation checks at each stage before you move to the next stage. This approach pushes updates to your production environments in a controlled way and minimizes unanticipated deployment problems. Use [blue-green deployment][blue-green-dep] and [canary release][canary-releases] strategies to update live production environments.
- Use a rollback strategy to handle failed deployments. For example, you can automatically redeploy an earlier, successful deployment from your deployment history. Use the `--rollback-on-error` flag in the Azure CLI.
- Use [Azure Monitor][azure-monitor] to analyze the performance of your data warehouse and the entire Azure analytics platform for an integrated monitoring experience. [Azure Synapse Analytics][synapse-analytics] provides a monitoring experience within the Azure portal to show insights about your data warehouse workload. Use the Azure portal to monitor your data warehouse. It provides configurable retention periods, alerts, recommendations, and customizable charts and dashboards for metrics and logs.

For more information, see the following resources:

- [Tutorial: Get started with Azure Synapse Analytics](/azure/synapse-analytics/get-started)
- [Create an Azure Synapse Analytics workspace by using the Azure CLI](/azure/synapse-analytics/quickstart-create-workspace-cli)

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

This section provides details about sizing decisions to accommodate this dataset.

#### Azure Synapse Analytics provisioned pool

You can use various [data warehouse configurations](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-manage-compute-overview).

|DWUs |Number of compute nodes  |Number of distributions per node|
|---------------------|:------------------:|:-------------------------:|
|DW100c               |1                   |60                         |
|                     | `-- TO --`         |                           |
|DW30000c             |60                  |1                          |

To see the performance benefits of scaling out, especially for larger DWUs, use at least a 1-TB dataset. To find the best number of DWUs for your dedicated SQL pool, try scaling up and down. Run queries that have different numbers of DWUs after you load your data. Scaling is quick, so you can easily experiment with various performance levels.

##### Find the best number of DWUs

For a dedicated SQL pool in development, select a small number of DWUs as a starting point, such as *DW400c* or *DW200c*. Monitor your application performance for each number of DWUs. Assume a linear scale, and determine how much you need to increase or decrease the DWUs. Continue making adjustments until you reach an optimum performance level for your business requirements.

##### Scale an Azure Synapse Analytics SQL pool

For scalability and performance optimization features of pipelines in Azure Synapse Analytics and of the copy activity that you use, see [Copy activity performance and scalability guide](/azure/data-factory/copy-activity-performance).

For more information, see the following resources:

- [Scale compute for an Azure Synapse Analytics SQL pool with the Azure portal](/azure/synapse-analytics/sql-data-warehouse/quickstart-scale-compute-portal)
- [Scale compute for a dedicated SQL pool with Azure PowerShell](/azure/synapse-analytics/sql-data-warehouse/quickstart-scale-compute-powershell)
- [Scale compute for a dedicated SQL pool in Azure Synapse Analytics by using T-SQL](/azure/synapse-analytics/sql-data-warehouse/quickstart-scale-compute-tsql)
- [Manage compute for a dedicated SQL pool](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-manage-compute-overview)

#### Power BI Premium and Fabric

This article uses the [Power BI Premium F64 capacity](/power-bi/enterprise/service-premium-what-is#capacities-and-skus) to demonstrate BI capabilities. Dedicated Power BI capacities in Fabric range from F64 (8 vCores) to F1024 (128 vCores).

To determine how much capacity you need:
- [Evaluate the load](/fabric/enterprise/optimize-capacity) on your capacity.
- Install the Fabric [capacity metrics app](/fabric/enterprise/metrics-app-install) for ongoing monitoring.
- Consider using workload-related [capacity optimization techniques](/fabric/enterprise/optimize-capacity#compute-optimization-by-fabric-experience).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Galina Polyakova](https://www.linkedin.com/in/galinagpolyakova/) | Senior Cloud Solution Architect
- [Noah Costar](https://www.linkedin.com/in/noah-costar-6204b8157/) | Cloud Solution Architect
- [George Stevens](https://www.linkedin.com/in/george-stevens/) | Cloud Solution Architect

Other contributors:

- [Jim McLeod](https://www.linkedin.com/in/jimmcleodaustralia/) | Cloud Solution Architect
- [Miguel Myers](https://www.linkedin.com/in/miguelmyers/) | Senior Program Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Power BI Premium?](/power-bi/enterprise/service-premium-what-is)
- [What is Microsoft Entra ID?](/entra/fundamentals/whatis)
- [Access Data Lake Storage and Azure Blob Storage with Azure Databricks](/azure/databricks/data/data-sources/azure/azure-storage)
- [What is Azure Synapse Analytics?](/azure/synapse-analytics/overview-what-is)
- [Pipelines and activities in Azure Data Factory and Azure Synapse Analytics](/azure/data-factory/concepts-pipelines-activities)
- [What is Azure SQL?](/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview)

## Related resources

- [Databases architecture design](../../databases/index.yml)
- [Analytics end-to-end with Azure Synapse Analytics](../../example-scenario/dataplate2e/data-platform-end-to-end.yml)

[azure-monitor]: https://azure.microsoft.com/services/monitor
[blue-green-dep]: https://martinfowler.com/bliki/BlueGreenDeployment.html
[canary-releases]: https://martinfowler.com/bliki/CanaryRelease.html
[e2e-analytics]: /azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end
[synapse-analytics]: /azure/sql-data-warehouse/sql-data-warehouse-concept-resource-utilization-query-activity
[adventureworksdw-sample-link]: /sql/samples/adventureworks-install-configure?view=sql-server-ver15&tabs=ssms
[az-storage-reserved]: /azure/storage/blobs/storage-blob-reserved-capacity
[enterprise-model]: /power-bi/guidance/center-of-excellence-business-intelligence-solution-architecture#enterprise-models
[bi-model]: /power-bi/guidance/center-of-excellence-business-intelligence-solution-architecture#bi-semantic-models
[pbi-premium-capacities]: /power-bi/enterprise/service-premium-what-is#capacities-and-skus
[synapse-dedicated-pool]: /azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is
