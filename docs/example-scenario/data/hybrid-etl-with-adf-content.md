This example scenario presents a hybrid solution for moving SQL Server databases to the cloud. The solution uses Azure Data Factory as the primary cloud-based extract, transform, and load (ETL) engine. To incorporate existing SQL Server Integration Services (SSIS) packages into the new cloud data workflow, the solution uses the Data Factory integration runtime.

## Architecture

![Digaram displaying an architecture overview of a hybrid ETL process that uses Azure Data Factory.][architecture-diagram]

*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/architecture-diagram-hybrid-etl-with-adf.vsdx) of this architecture.*

### Dataflow

1. Data is sourced from Azure Blob Storage into Data Factory.
2. The Data Factory pipeline invokes a stored procedure to run an SSIS job that's hosted on-premises via the integration runtime.
3. The data cleansing jobs are run to prepare the data for downstream consumption.
4. After the data cleansing task finishes successfully, a copy task is run to load the clean data into Azure.
5. The clean data is then loaded into tables in Azure Synapse Analytics.

### Components

- [Blob Storage](https://azure.microsoft.com/products/storage/blobs) is used to store files and as a source for Data Factory to retrieve data.
- [SQL Server Integration Services][docs-ssis] contains the on-premises ETL packages that are used to run task-specific workloads.
- [Data Factory](https://azure.microsoft.com/services/data-factory) is the cloud orchestration engine that takes data from multiple sources and combines, orchestrates, and loads the data into a data warehouse.
- [Azure Synapse Analytics](https://azure.microsoft.com/products/synapse-analytics) centralizes data in the cloud. You can easily access the data by using standard ANSI SQL queries.

### Alternatives

Data Factory can invoke data cleansing procedures implemented by using other technologies, such as a Databricks notebook, Python script, or SSIS instance running in a virtual machine (VM). [Installing paid or licensed custom components for the Azure-SSIS integration runtime](/azure/data-factory/how-to-develop-azure-ssis-ir-licensed-components) might be a viable alternative to the hybrid approach.

## Scenario details

When you migrate your SQL Server databases to the cloud, you can realize tremendous cost savings, performance gains, added flexibility, and greater scalability. However, reworking existing ETL processes that are built with SSIS can be a migration roadblock. In other cases, the data load process requires complex logic or specific data tool components that aren't yet supported by Data Factory v2. Commonly used SSIS capabilities include Fuzzy Lookup and Fuzzy Grouping transformations, Change Data Capture (CDC), Slowly Changing Dimensions (SCD), and Data Quality Services (DQS).

To facilitate a *lift and shift* migration of an existing SQL database, a hybrid ETL approach provides a suitable option. A hybrid approach uses Data Factory as the primary orchestration engine, but continues to use existing SSIS packages to clean data and work with on-premises resources. The approach in this article uses the Data Factory SQL Server integration runtime to enable a lift and shift migration of existing databases into the cloud, while incorporating existing code and SSIS packages into the new cloud data workflow.

Traditionally, SSIS has been the ETL tool of choice for many SQL Server data professionals for data transformation and loading. Many organizations have invested significantly in developing SSIS ETL packages for specific data tasks. Sometimes, specific SSIS features or third-party plugging components have been used to accelerate the development effort.

Replacement or redevelopment of these packages might not be an option, because rewriting these packages can be daunting. Also, many existing code packages have dependencies on local resources, preventing migration to the cloud. Data Factory provides a way for you to take advantage of your existing ETL packages but limit further investment in on-premises ETL development. This solution is a low-impact approach to migrating existing databases to the cloud.

### Potential use cases

The solution applies to many scenarios:

- Loading network router logs to a database for analysis
- Preparing human resources employment data for analytical reporting
- Loading product and sales data into a data warehouse for sales forecasting
- Automating loading of operational data stores or data warehouses for finance and accounting

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

The integration runtime supports two models: a self-hosted integration runtime or an Azure-hosted integration runtime. You first must decide between these two options. Self-hosting is more cost effective but has more overhead for maintenance and management. For more information, see [Self-hosted IR](/azure/data-factory/concepts-integration-runtime#self-hosted-integration-runtime). If you need help with determining which integration runtime to use, see [Determining which IR to use](/azure/data-factory/concepts-integration-runtime#determining-which-ir-to-use).

For the Azure-hosted approach, you should decide how much power is required to process your data. The Azure-hosted configuration allows you to select the VM size as part of the configuration steps. To learn more about selecting VM sizes, see [VM performance considerations](/azure/cloud-services/cloud-services-sizes-specs#performance-considerations).

The decision is much easier when you already have existing SSIS packages that have on-premises dependencies such as data sources or files that aren't accessible from Azure. In this scenario, your only option is the self-hosted integration runtime. This approach provides the most flexibility to use the cloud as the orchestration engine, without having to rewrite existing packages.

Ultimately, the intent is to move the processed data into the cloud for further refinement or combining with other data stored in the cloud. As part of the design process, keep track of the number of activities used in the Data Factory pipelines. For more information, see [Pipelines and activities in Azure Data Factory](/azure/data-factory/concepts-pipelines-activities).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Data Factory is a cost-effective way to orchestrate data movement in the cloud. The cost is based on the number of:

- Pipeline executions.
- Entities/activities used within the pipeline.
- Monitoring operations.
- Integration runtimes (Azure-hosted integration runtime or self-hosted integration runtime).

Data Factory uses consumption-based billing. Therefore, cost is only incurred during pipeline executions and monitoring. The execution of a basic pipeline would cost as little as 50 cents and the monitoring as little as 25 cents. To create a more accurate estimate based on your specific workload, use the [Azure cost calculator](https://azure.microsoft.com/pricing/calculator).

When running a hybrid ETL workload, you must factor in the cost of the VM used to host your SSIS packages. This cost is based on the size of the VM ranging from a D1v2 (1 core, 3.5 GB RAM, 50 GB disk) to E64V3 (64 cores, 432 GB RAM, 1600 GB disk). If you need further guidance on selection the appropriate VM size, see [VM performance considerations](/azure/cloud-services/cloud-services-sizes-specs#performance-considerations).

## Contributors

*This article is being updated and maintained by Microsoft. It was originally written by the following contributor.*

Principal author:

- [Alex Hieng](https://www.linkedin.com/in/alex-hieng-8476352) | Senior Cloud Specialist

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Data Factory][docs-data-factory]
- [SQL Server Integration Services][docs-ssis]
- [Provision the Azure-SSIS integration runtime in Azure Data Factory](/azure/data-factory/tutorial-deploy-ssis-packages-azure)
- [Azure Synapse Analytics][docs-sql-data-warehouse]
- [Blob Storage][docs-blob-storage]

## Related resources

- [Extract, transform, and load (ETL)](../../data-guide/relational-data/etl.yml)
- [Ingestion, ETL, and stream processing pipelines with Azure Databricks](../../solution-ideas/articles/ingest-etl-stream-with-adb.yml)
- [Data analysis workloads for regulated industries](/azure/architecture/example-scenario/data/data-warehouse)

<!-- links -->

[architecture-diagram]: ./media/architecture-diagram-hybrid-etl-with-adf-new.png
[docs-blob-storage]: /azure/storage/blobs/storage-blobs-overview
[docs-data-factory]: /azure/data-factory/introduction
[docs-ssis]: /sql/integration-services/sql-server-integration-services
[docs-sql-data-warehouse]: /azure/sql-data-warehouse/sql-data-warehouse-overview-what-is