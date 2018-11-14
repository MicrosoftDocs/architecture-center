---
title: Hybrid ETL with existing on-premises SSIS and Azure Data Factory v2
description: Hybrid ETL with existing on-premises SSIS and Azure Data Factory v2
author: alhieng
ms.date: 9/20/2018
---

# Hybrid ETL with existing on-premises SSIS and Azure Data Factory v2

Organizations that migrate their SQL Server database to the cloud can realize tremendous cost savings, performance gains, added flexibility and more scalability.  However, reworking of existing SSIS ETL processes may be the road block preventing the migration.  In other cases, the data loading process requires complex logic and/or specific data tool components are not yet supported by Azure Data Factory v2 (ADF).  Some of these SSIS components most often used are as follows: Fuzzy Lookup, Fuzzy Grouping, CDC, SCD and Data Quality Services (DQS).

To facilitate the lift-and-shift migration of an existing SQL database, a hybrid ETL approach may be the most suitable option.  The hybrid approach uses ADF as the primary orchestration engine but continues to leverage existing SSIS packages to do data cleansing, and work with on-premise resources.  This hybrid approach is achieved by using ADF SQL Server Integrated Runtime (IR).  The hybrid ETL approach allows a lift-and-shift of existing databases into the cloud, while using existing code and SSIS packages.

This example scenario is relevant to organizations that are moving databases to the cloud and are considering using ADF as the primary cloud-based extract-transform-load (ETL) engine and want to incorporate existing SQL Server Integration Services (SSIS) packages into their new cloud data workflow. Organizations often have already invested greatly in developing ETL packages using SSIS for specific data tasks. Rewriting these packages can be a daunting task. In addition, many existing code packages may have dependencies on local resources, preventing migration to the cloud.
ADF lets customers take advantage of their existing ETL packages while limiting further investment to on-premises ETL development. This example discusses some potential use cases where existing SSIS packages can be leveraged as part of a new cloud data workflow using Azure Data Factory v2.

## Potential use cases

Traditionally, SQL Server Integrations Services (SSIS) has been the tool of choice for many SQL Server data professionals for data transformation and loading.  Very often these SSIS packages contain SSIS components such as Fuzzy grouping, Fuzzy Lookup, CDC, SDC components are used to cleanse and transform data.  Sometimes, third-party plugging components are also used to accelerate the development effort. Replacement or redevelopment of these packages may not be an option preventing customers from migrating their databases to the cloud.  Customers are looking for low impact ways to migrate their existing database to the cloud and leverage their existing SSIS packages. 
Server potential on-premise use cases are listed below:

* SSIS package used to load network router logs to a database for analysis
* SSIS package used to prepare and clean human resource employment data used for analytics reporting
* SSIS package used to load product and sales data into a data warehouse for sales forecasting
* SSIS package used to automate ODS/DW loading for finance and accounting

## Architecture

![Architecture overview of a hybrid ETL process using Data Factory][architecture-diagram]

1. Data is sourced from Blob storage into Data Factory.
2. The Data Factory pipeline invokes a stored procedure to execute an SSIS job hosted on-premises via the Data Factory Integrated Runtime.
3. The data cleansing jobs are executed to prepare the data for downstream consumption
4. Once the data cleansing task completes successfully, a copy task is executed to load the clean data into Azure
5. The clean data is then loaded into tables in the SQL Data Warehouse.

### Components

* [Blob storage][docs-blob-storage] is used to store files and as a source for Data Factory to retrieve data.
* [SQL Server Integration Services][docs-ssis] contains the on-premises ETL packages used to execute task-specific workloads.
* [Azure Data Factory][docs-data-factory] is the cloud orchestration engine that takes data from multiple sources and combines, orchestrates, and load the data into a data warehouse.
* [SQL Data Warehouse][docs-sql-data-warehouse] is used to centralize data in the cloud for easy access using standard ANSI SQL queries.

### Alternatives

Data Factory could invoke data cleansing procedures implemented using other technologies, such as a Databricks notebook, Python script, or SSIS instance running in a virtual machine. [Install paid or licensed custom components on Azure-hosted IR][] may be an alternative to the hybrid approach.

## Considerations

Integrated Runtime (IR) supports two models, self-hosted IR or Azure-hosted IR.  You must first decide between these two options.  Self-hosting is more cost effective but requires more overhead for you to maintain and manage. You can learn more at [Self-hosted IR](https://docs.microsoft.com/en-us/azure/data-factory/concepts-integration-runtime#self-hosted-integration-runtime).  If you need help determining which IR to use you can read more on “[Determine which IR to use](https://docs.microsoft.com/en-us/azure/data-factory/concepts-integration-runtime#determining-which-ir-to-use)”

In the case of Azure-hosted scenario, you should decide how much power is required to process your data.  The Azure-hosted configuration allows you to select the VM size as part of the configuration steps.  To learn more about selecting VM sizes you can read on [VM performance considerations](https://docs.microsoft.com/en-us/azure/cloud-services/cloud-services-sizes-specs#performance-considerations).

The decision is much easier when you already have existing SSIS packages that have on-premise dependencies such as data sources, or files which are not accessible from Azure.  In this scenario, your only option is Self-hosted IR. This approach provides the most flexibility to leverage the cloud as the orchestration engine, without having to rewrite existing packages.

Ultimately, the intent is to move the processed data into the cloud for further refinement or to combine with other data stored in the cloud.  As part of the design process, keep track of the number of activities used in the ADF pipelines.  You can learn more about [pipelines and activities](https://docs.microsoft.com/en-us/azure/data-factory/concepts-pipelines-activities).

### Availability, Scalability, and Security

> How do I need to think about managing, maintaining, and monitoring this long term?

> Are there any size considerations around this specific solution?  
> What scale does this work at?  
> At what point do things break or not make sense for this architecture?

> Are there any security considerations (past the typical) that I should know about this?

## Pricing

Azure Data Factory is a very cost-effective way to orchestrate data movement in the cloud.  The cost is based on the several factors.

* Number of pipelines executions
* Number of entities/activities used within the pipeline
* Number of monitoring operations
* Number of Integration Runs (Azure-hosted IR or Self-hosted IR)

ADF uses a consumption-based billing; therefore, cost is only incurred during pipeline executions and monitoring.  The execution of a basic pipeline would cost as little as $0.50 cents and the monitoring as little as $25 cents. The [Azure cost calculator](https://azure.microsoft.com/en-us/pricing/calculator/) can be used to create a more accurate estimate based on your specific work load.

When running a hybrid ETL workload, you must factor in the cost of the Virtual machine used to host your SSIS packages. This is explained in the above considerations section of this document. This cost is based on the size of the VM ranging from a D1v2 (1 core, 3.5 GB RAM, 50GB Disk) to E64V3 (64 cores, 432GB RAM, 1600GB Disk).  If you need further guidance on selection the appropriate VM size refer to [VM performance considerations](https://docs.microsoft.com/en-us/azure/cloud-services/cloud-services-sizes-specs#performance-considerations).

## Next Steps

* To learn more about [Azure Data Factory](https://azure.microsoft.com/en-us/services/data-factory/)
* Get started with Azure Data Factory by following the [Step-by-Step tutorial](https://docs.microsoft.com/en-us/azure/data-factory/#step-by-step-tutorials)
* [Provision the Azure-SSIS Integration Runtime in Azure Data Factory](https://docs.microsoft.com/en-us/azure/data-factory/tutorial-deploy-ssis-packages-azure)


<!-- links -->
[architecture-diagram]: ./media/architecture-diagram-hybrid-etl-with-adf.png
[small-pricing]: https://azure.com/e/
[medium-pricing]: https://azure.com/e/
[large-pricing]: https://azure.com/e/
[availability]: /azure/architecture/checklist/availability
[resource-groups]: /azure/azure-resource-manager/resource-group-overview
[resiliency]: /azure/architecture/resiliency/
[security]: /azure/security/
[scalability]: /azure/architecture/checklist/scalability

[docs-blob-storage]: /azure/storage/blobs/
[docs-data-factory]: /azure/data-factory/introduction
[docs-resource-groups]: /azure/azure-resource-manager/resource-group-overview
[docs-ssis]: /sql/integration-services/sql-server-integration-services