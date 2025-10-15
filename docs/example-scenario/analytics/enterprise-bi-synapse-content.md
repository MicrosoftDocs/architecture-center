This article describes how to transfer data from an on-premises data warehouse to a cloud environment and then use a business intelligence (BI) model to serve the data. You can use this approach as an end goal or a first step toward full modernization with cloud-based components.

This guidance builds on the [Microsoft Fabric end-to-end scenario][e2e-analytics]. This process has multiple options to extract data from on-premises SQL Server such as Fabric Data Factory pipelines, Mirorring, COPY JOB, Fabric Real Time Eventstreams CDC for SQL. Then it performs data transformation for analysis. 


## When to use this architecture

You can use various methods to meet business requirements for enterprise BI. Various aspects define business requirements, such as current technology investments, human skills, the timeline for modernization, future goals, and whether you have a preference for platform as a service (PaaS) or software as a service (SaaS). 

Consider the following design approaches:

- [A lakehouse in Microsoft Fabric](/azure/architecture/example-scenario/data/greenfield-lakehouse-fabric)

- [Fabric and Azure Databricks](/azure/architecture/solution-ideas/articles/small-medium-modern-data-platform) for customers that have existing investment in Azure Databricks and Power BI and want to modernize with Fabric 
- Enterprise BI for small and medium businesses that use an [Azure SQL ecosystem and Fabric](/azure/architecture/example-scenario/data/small-medium-data-warehouse)
- Data warehousing completely on Fabric for customers that prefer SaaS

The architecture in this article assumes that you use Microsoft Fabric data Lakehouse/Warehouse as the persistent layer of the enterprise semantic model and you use Power BI for business intelligence. This SaaS approach has the flexibility to accommodate various business requirements and preferences.

## Architecture

:::image type="complex" source="./media/enterprise-bi-scoped-architecture.svg" border="false" lightbox="./media/enterprise-bi-scoped-architecture.svg" alt-text="Diagram that shows the enterprise BI architecture with Microsoft Fabric.":::
The diagram shows types of input, like data streams, databases, data services, unstructured data, and structured data. Components in the Ingest phase receive the data input. The Ingest phase components are Azure Event Hubs, Azure IoT Hub, Fabric Pipelines, Fabric RTI Eventstreams, Mirroring & COPY JOBS. Microsoft Fabric OneLake is the primary storage for the Store phase via multiple options such as Lakehouse/Warehouse, Eventhouse or Mirrored DBs. Then the data goes to the Process phase for Fabric Eventstreams & KQL Query sets to process the data in real time & Spark notebooks, SQL Scripts, and Dataflows Gen2 for batch workloads. Some of the machine learning models data goes to the Enrich phase, which contains Azure AI Foundry and Azure Machine Learning. The other data goes to the Serve phase, which contains Power BI, Fabric Data Agents, and OneLake shortcuts. The data outputs to business users, analytics, applications, and shared datasets.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/enterprise-bi-scoped-architecture.vsdx) of this architecture.*

### Workflow

#### Data source

- A SQL Server database in Azure contains the source data. To simulate the on-premises environment, deployment scripts for this scenario configure an Azure SQL database. The [AdventureWorks sample database][adventureworksdw-sample-link] is used as the source data schema and sample data. For more information, see [Copy and transform data to and from SQL Server](/azure/data-factory/connector-sql-server).

#### Ingestion and data storage

- [Microsoft Fabric OneLake](/fabric/onelake/onelake-overview) is single, unified, logical data lake for your whole organization. This SaaS offers various data storage options such as a [Fabric Lakehouse](/fabric/data-engineering/lakehouse-overview) for data engineering lakehouse workloads, [Fabric Warehouse](/fabric/data-warehouse/data-warehousing) for data warehouse workloads, and [Fabric Eventhouse](/fabric/real-time-intelligence/eventhouse) for high volume time series and log datasets.

- [Microsoft Fabric Data Factory Pipelines](/fabric/data-factory/data-factory-overview#data-pipelines) to build complex ETL and data factory workflows that can perform many different tasks at scale. Control flow capabilities are built into data pipelines that allow you to build workflow logic, which provides loops and conditionals. Here, metadata driven frameworks are used for incremental ingestion for multiple tables at scale.

- [Microsoft Fabric Data Factory Mirroring](/fabric/mirroring/sql-server) provides an easy experience to avoid complex ETL (Extract Transform Load) and integrate your existing SQL Server estate with the rest of your data in Microsoft Fabric. You can continuously replicate your existing SQL Server databases directly into Fabric's OneLake. [Microsoft Fabric Data Factory COPY Job](/fabric/data-factory/what-is-copy-job) makes it easy to move data from your source to your destination--no pipelines required. With a simple, guided experience, you can set up data transfers using built-in patterns for both batch and incremental copy with highly scalable performance. 

- [Microsoft Fabric Eventstreams](/fabric/real-time-intelligence/event-streams/add-source-sql-server-change-data-capture) offers high throughput real time data ingestion from a SQL Server database on VM using CDC extraction. This pattern is suitable for use cases that needs real time dashboards and alerting.




#### Analysis and reporting

- The data-modeling approach in this scenario combines the [enterprise model][enterprise-model] and the [BI semantic model][bi-model]. Fabric FSKUs provide the compute for Power BI semantic models as explained in [Fabric capacity](/fabric/enterprise/powerbi/service-premium-what-is#capacities-and-skus). Power BI can access the data via Import, DirectQuery or DirectLake connectivity.

### Components

This scenario uses the following components:

- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) is an Azure-hosted PaaS SQL server. This architecture uses SQL Database to demonstrate the flow of data for the migration scenario. 

- [Fabric OneLake Storage](/fabric/onelake/onelake-overview) provides unified cloud storage for all structured & unstructured data for the whole organization. This architecture uses OneLake storage artifacts such as Lakehouse/Warehouse, Eventhouse, and Mirrored db to store various types of data.
- [Fabric DataWarehouse](/fabric/data-warehouse/data-warehousing) is a SaaS offering to host data warehouse workloads for large datasets. This architecture uses Fabric DW as final store of dimensional datasets.
- [Power BI](/power-bi/enterprise/service-premium-what-is) is a BI tool hosted on Fabric compute that presents and visualizes data in this scenario.
- [Microsoft Entra ID](/entra/fundamentals/whatis) is a multicloud identity and network solution suite that supports the authentication and authorization flow.

## Scenario details

In this scenario, an organization has an SQL database that contains a large on-premises data warehouse. The organization wants to use Microsoft Fabric to perform ingestion, analysis, and deliver these analytic insights via Power BI to end users.

### Authentication

Microsoft Entra ID authenticates users who connect to Power BI dashboards and apps. Single sign-on connects users to the data in Fabric Warehouse and Power BI semantic model. Authorization occurs on the source.

### Incremental loading

When you run an automated extract, transform, load (ETL) or extract, load, transform (ELT) process, you should load only the data that changed since the previous run. This process is called as an [incremental load](/fabric/data-factory/tutorial-incremental-copy-data-warehouse-lakehouse). Conversely, a full load loads all the data. To perform an incremental load, determine how to identify the changed data. You can use a *high water mark* value approach, which tracks the latest value of a date-time column or a unique integer column in the source table.

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

1. Pick a watermark column. Choose one column in your source table that helps track new or changed records. This column usually contains values that increase when rows are added or updated (like a timestamp or ID). We use the highest value in this column as our "watermark" to know where we left off.

1. Set up a table to store your last watermark value.

1. Build a pipeline that does the following tasks:

    The pipeline includes these activities:

      - Two lookup activities. The first one gets the last watermark value (where we stopped last time). The second one gets the new watermark value (where  we'll stop this time). Both values get passed to the copy activity.
      - A copy activity that finds rows where the watermark column value is between the old and new watermarks. It then copies this data from your Data Warehouse to your Lakehouse as a new file.
      - A stored procedure activity that saves the new watermark value so the next pipeline run knows where to start.

:::image type="content" source="./media/metadata-copy.png" alt-text="Logic of metadata driven framework." lightbox="./media/metadata-copy.png":::

A completed pipeline looks as below. More details about implementation can be found at [Incremental ingestion](/fabric/data-factory/tutorial-incremental-copy-data-warehouse-lakehouse)

:::image type="content" source="./media/metadata-ingestion-pipeline.png" alt-text="Completed pipeline metadata driven framework." lightbox="./media/metadata-copy.png":::



### Load data into a Microsoft Fabric Data Warehouse

The [copy activity](/fabric/data-factory/copy-data-activity) copies data from the SQL database into the Fabric Data Warehouse. This example's SQL database is in Azure, so it uses a connection set up within the Fabric portal under "Manage Connection & Gateways".


### Use Microsoft Fabric Data Factory Pipelines

Pipelines in Microsoft Fabric Data Factory pipelines define an ordered set of activities to complete an incremental load pattern. Manual or automatic triggers start the pipeline.

### Transform the data

If transformation is needed, then [Fabric Dataflows](/fabric/data-factory/dataflows-gen2-overview) should be used to design low code AI-assisted ETL transformations to change nature of data. It uses the PowerQuery engine to execute transformations and writes output of transformation to Fabric Data Warehouse.

In a production environment, [Fabric Notebooks](/fabric/data-engineering/how-to-use-notebook) should be used for implementing ETL transformations that work well for large datasets via an Apache Spark driven distributed computing framework.


> [!NOTE]
> Use the [Native Execution engine](/fabric/data-engineering/native-execution-engine-overview?tabs=sparksql) for running data engineering or ETL workloads.

### Use Power BI on Fabric Capacities to access, model, and visualize data

Power BI on Fabric Capacities supports several options to connect to data sources on Azure. You can use Fabric Data Warehouse to do the following tasks:

- Import: The data is imported into the Power BI model.
- [DirectQuery](/power-bi/connect-data/desktop-directquery-about): Data is pulled directly from relational storage.
- [Composite model](/power-bi/transform-model/desktop-composite-models): Combine *Import* for some tables and *DirectQuery* for others.
- [DirectLake](/fabric/fundamentals/direct-lake-overview): is a storage mode option for tables in a Power BI semantic model that's stored in a Microsoft Fabric workspace. It's optimized for large volumes of data that can be quickly loaded into memory from Delta tables stored in OneLake that enables high performance interactive analysis on very large tables.

This scenario uses the DirectQuery dashboard because it has a small amount of data and low model complexity. DirectQuery delegates the query to the underlying compute engine and uses security capabilities on the source. DirectQuery ensures that results are always consistent with the latest source data.

Import mode can provide the lowest query latency. Consider import mode if:

- The model fits entirely within the memory of Power BI.
- The data latency between refreshes is acceptable.
- You require complex transformations between the source system and the final model.

In this case, the end users want full access to the most recent data with no delays in Power BI refreshing, and they want all historical data, which exceeds the Power BI dataset capacity. A Power BI dataset can handle 25-400 GB, depending on the capacity size. The data model in the dedicated SQL pool is already in a star schema and doesn't require transformation, so DirectQuery is an appropriate choice.

:::image type="content" source="./media/adventure-works-dashboard.png" alt-text="Screenshot that shows the dashboard in Power BI." lightbox="./media/adventure-works-dashboard.png":::

Use [Power BI](/power-bi/enterprise/service-premium-gen2-what-is) to manage large models, paginated reports, and deployment pipelines. Take advantage of the built-in Azure Analysis Services endpoint. You can also have dedicated [capacity](/power-bi/admin/service-premium-what-is#capacities-and-skus) with unique value proposition.

When the BI model grows or dashboard complexity increases, you can switch to composite models and import parts of lookup tables via [hybrid tables](/power-bi/connect-data/service-dataset-modes-understand#hybrid-tables), and import preaggregated data. You can enable [query caching](/power-bi/connect-data/power-bi-query-caching) within Power BI for imported datasets and use [dual tables](/power-bi/transform-model/desktop-storage-mode) for the storage mode property.

Within the composite model, datasets serve as a virtual pass-through layer. When users interact with visualizations, Power BI generates SQL queries to Microsoft Fabric Data Warehouse. Power BI determines whether to use in-memory or DirectQuery storage based on efficiency. The engine decides when to switch from in-memory to DirectQuery and pushes the logic to the Fabric Data Warehouse. Depending on the context of the query tables, they can act as either cached (imported) or non-cached composite models. You can choose which table to cache into memory, combine data from one or more DirectQuery sources, or combine DirectQuery source data and imported data.

When you use DirectQuery with a Fabric Data Warehouse or Lakehouse:

- Use Fabric [Z-Ordering & V-Ordering](/fabric/data-engineering/delta-optimization-and-v-order?tabs=sparksql) to improve query performance by optimizing storage of underlying table data in delta format files.

- Use Fabric Lakehouse [materialized views](/fabric/data-engineering/materialized-lake-views/overview-materialized-lake-view) to precompute, store, and maintain data like a table. Queries that use all data or a subset of the data in materialized views can achieve faster performance without needing to directly reference the defined materialized view to use it.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

#### Microsoft Fabric reliability

This document on [Reliability](/azure/reliability/reliability-fabric) describes reliability support in Microsoft Fabric, and both regional resiliency with availability zones and cross-region recovery and business continuity. Fabric provides a disaster recovery switch on the capacity settings page. It's available where Azure regional pairings align with Fabric's service presence. When the disaster recovery capacity setting is turned on, cross-region replication is enabled as a [disaster recovery](/azure/reliability/reliability-fabric#disaster-recovery-capacity-setting) capability for OneLake data.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Cloud modernization introduces security concerns, such as data breaches, malware infections, and malicious code injection. You need a cloud provider or service solution that can address your concerns because inadequate security measures can create major problems.

This scenario addresses the most demanding security concerns by using a combination of layered security controls: network, identity, privacy, and authorization controls. A Microsoft Fabric Data Warehouse stores most of the data. Power BI accesses the data via DirectQuery through single sign-on. You can use Microsoft Entra ID for authentication. There are also extensive security controls for data authorization within the provisioned pools.

Some common security questions include:

- Define who can see what data.
  - Ensure that your data complies with federal, local, and company guidelines to mitigate data breach risks. Microsoft Fabric provides holistic security coverage [data protection capabilities](/fabric/security/security-overview) to achieve compliance.
  - [OneLake Security](/fabric/onelake/security/get-started-security) controls all access to OneLake data with different permissions inherited from the parent item or workspace permissions.

      - Workspace: a collaborative environment for creating and managing items. Workspace roles can be managed at this level.
      
      - Item: a set of capabilities bundled together into a single component. A data item is a subtype of item that allows data to be stored within it using  
        OneLake. Items inherit permissions from the workspace roles, but can have additional permissions as well.

      - Folders: folders within an item that are used for storing and managing data, such as Tables/ or Files/

- Determine how to verify a user's identity.
  - Use Microsoft Fabric to control who can access what data via [access control](/fabric/security/white-paper-landing-page) and [authentication](/fabric/security/workspace-identity-authenticate).
- Choose a network security technology to protect the integrity, confidentiality, and access of your networks and data.
  - Help secure Microsoft Fabric by using [network security](/fabric/security/protect-inbound-traffic) options.
- Choose tools to detect and notify you of threats.
  - Use Azure Synapse Analytics [threat detection](/azure/synapse-analytics/guidance/security-white-paper-threat-protection) capabilities, such as SQL auditing, SQL threat detection, and vulnerability assessment to audit, protect, and monitor databases.
- Determine how to protect data in your storage account.
  - Use Azure Storage accounts for workloads that require fast and consistent response times or that have a high number of input/output operations (IOPs) per second. Storage accounts can store all your data objects and have several [storage account security options](/azure/well-architected/service-guides/azure-blob-storage#security).


### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

This section provides information about pricing for different services involved in this solution, and mentions decisions made for this scenario with a sample dataset. Use this starting configuration in the [Azure pricing calculator](https://azure.com/e/598c407dc58545e090c8cfd6c7dbc190), and adjust it to fit your scenario. Use the [Fabric pricing overview](https://azure.microsoft.com/en-us/pricing/details/microsoft-fabric/) for detailed information on Fabric F SKUs and [Fabric Capacity Estimator](https://www.microsoft.com/en-us/microsoft-fabric/capacity-estimator) to generate an estimate of overall Fabric consumption.

#### Microsoft Fabric Scalable architecture

Microsoft Fabric is a serverless architecture for most workloads that you can use to scale your compute and storage levels independently. Compute resources incur costs based on usage. You can scale or pause these resources on demand. Storage resources incur costs per terabyte, so your costs increase as you ingest data.

#### Microsoft Fabric Factory pipelines

Three main components influence the price of a pipeline:

- Data pipeline activities for orchestration
- Dataflow Gen2 for compute
- Data movement for Copy job

For pricing details, see the *Data Factory pricing meters* tab on [Data Factory pricing](/fabric/data-factory/pricing-overview). 

The price varies depending on components or activities, frequency, and overall compute associated with orchestration. 

#### Microsoft Fabric Data Lakehouse or Warehouse or Eventhouse

Use this [decision guide](/fabric/fundamentals/decision-guide-data-store) to help you choose a data store for your Microsoft Fabric workloads, all available in a unified storage in the OneLake.

The SQL Endpoint for Fabric Lakehouse or Warehouse offers the capability to execute ad-hoc queries for analysis, as well as allowing Power BI semantic models to import or direct query the data. The cost associated with a Lakehouse or Warehouse is equivalent to the [CUs consumption](/fabric/enterprise/azure-billing) for SQL queries against the SQL endpoint.

#### OneLake storage

OneLake storage is billed at a pay-as-you-go rate per GB of data used and doesn't consume Fabric Capacity Units (CUs). Fabric items like lakehouses and warehouses consume OneLake storage. For more information about pricing, see [Fabric pricing](https://azure.microsoft.com/en-us/pricing/details/microsoft-fabric/)

#### Power BI 

This scenario uses [Power BI workspaces](/power-bi/admin/service-premium-what-is) with built-in performance enhancements to accommodate demanding analytical needs.

For more information, see [Power BI pricing](https://powerbi.microsoft.com/pricing).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- Use an Azure DevOps release pipeline and GitHub Actions to automate the deployment of a Microsoft Fabric workspace artifact across multiple environments. For more information, see [Continuous integration and continuous delivery for Microsoft Fabric workspace](/fabric/cicd/manage-deployment).
- Put each workload in a separate deployment template, and store the resources in source control systems. You can deploy the templates together or individually as part of a continuous integration and continuous delivery (CI/CD) process. This approach simplifies the automation process. This architecture has four main workloads:
  - The data warehouse and related resources
  - Data Factory pipelines
  - Power BI assets, including dashboards, apps, and datasets
  - An on-premises to cloud simulated scenario

- Consider staging your workloads where practical. Deploy your workload to various stages. Run validation checks at each stage before you move to the next stage. This approach pushes updates to your production environments in a controlled way and minimizes unanticipated deployment problems. Use [blue-green deployment][blue-green-dep] and [canary release][canary-releases] strategies to update live production environments.
- Use a rollback strategy to handle failed deployments. For example, you can automatically redeploy an earlier, successful deployment from your deployment history. Use the `--rollback-on-error` flag in the Azure CLI.
- Use [Fabric Capacity Metrics app](/fabric/enterprise/metrics-app) for comprehensive monitoring of Fabric capacity consumption, [Workspace Monitoring](/fabric/fundamentals/workspace-monitoring-overview) for detailed monitoring of Fabric Workspace telemetry logs.
- Use [Fabric Capacity Estimator](https://www.microsoft.com/en-us/microsoft-fabric/capacity-estimator?msockid=2cafadf0224a6692090fbbc023586769) to estimate your Fabric Capacity needs.


### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

This section provides details about sizing decisions to accommodate this dataset.


#### Power BI on Fabric Capacity

This article uses the [Fabric F64 capacity](/power-bi/enterprise/service-premium-what-is#capacities-and-skus) to demonstrate BI capabilities. Dedicated Power BI capacities in Fabric range from F64 (8 vCores) to F1024 (128 vCores).

To determine how much capacity you need:

- [Evaluate the load](/fabric/enterprise/optimize-capacity) on your capacity.
- Install the Fabric [capacity metrics app](/fabric/enterprise/metrics-app-install) for ongoing monitoring.
- Consider using workload-related [capacity optimization techniques](/fabric/enterprise/optimize-capacity#compute-optimization-by-fabric-experience).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Bibhu Acharya](https://www.linkedin.com/in/bibhu-acharya-1848b1132/) | Principal Cloud Solution Architect

Other contributors:

- [Galina Polyakova](https://www.linkedin.com/in/galinagpolyakova/) | Senior Cloud Solution Architect
- [George Stevens](https://www.linkedin.com/in/george-stevens/) | Solution Engineer
- [Jim McLeod](https://www.linkedin.com/in/jimmcleodaustralia/) | Cloud Solution Architect
- [Miguel Myers](https://www.linkedin.com/in/miguelmyers/) | Senior Program Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Power BI?](/power-bi/enterprise/service-premium-what-is)
- [What is Microsoft Entra ID?](/entra/fundamentals/whatis)
- [Access Data Lake Storage and Azure Blob Storage with Azure Databricks](/azure/databricks/data/data-sources/azure/azure-storage)
- [What is Microsoft Fabric?](/fabric/fundamentals/microsoft-fabric-overview)
- [Pipelines and activities in Microsoft Fabric Data Factory](/fabric/data-factory/data-factory-overview)
- [What is Azure SQL?](/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview)

## Related resources

- [Databases architecture design](../../databases/index.yml)
- [Analytics end-to-end with Azure Synapse Analytics](../../example-scenario/dataplate2e/data-platform-end-to-end.yml)

[azure-monitor]: https://azure.microsoft.com/services/monitor
[blue-green-dep]: https://martinfowler.com/bliki/BlueGreenDeployment.html
[canary-releases]: https://martinfowler.com/bliki/CanaryRelease.html
[e2e-analytics]: /azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end
[adventureworksdw-sample-link]: /sql/samples/adventureworks-install-configure?view=sql-server-ver15&tabs=ssms
[az-storage-reserved]: /azure/storage/blobs/storage-blob-reserved-capacity
[enterprise-model]: /power-bi/guidance/center-of-excellence-business-intelligence-solution-architecture#enterprise-models
[bi-model]: /power-bi/guidance/center-of-excellence-business-intelligence-solution-architecture#bi-semantic-models
[pbi-premium-capacities]: /power-bi/enterprise/service-premium-what-is#capacities-and-skus

