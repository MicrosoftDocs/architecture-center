This reference architecture shows how to perform incremental loading in an [extract, load, and transform (ELT)](../../data-guide/relational-data/etl.yml#extract-load-and-transform-elt) pipeline. It uses Azure Data Factory to automate the ELT pipeline. The pipeline incrementally moves the latest OLTP data from an on-premises SQL Server database into Azure Synapse. Transactional data is transformed into a tabular model for analysis.

![GitHub logo](../../_images/github.png) A reference implementation for this architecture is available on [GitHub][github].

## Architecture

![Architecture diagram for automated enterprise BI with Azure Synapse Analytics and Azure Data Factory.](./images/enterprise-bi-data-factory.svg)

*Download a [Visio file](https://arch-center.azureedge.net/enterprise-bi-adf.vsdx) of this architecture.*

This architecture builds on the one shown in [Enterprise BI with Azure Synapse](/azure/architecture/example-scenario/analytics/enterprise-bi-synapse), but adds some features that are important for enterprise data warehousing scenarios.

- Automation of the pipeline using Data Factory.
- Incremental loading.
- Integrating multiple data sources.
- Loading binary data such as geospatial data and images.

### Workflow

The architecture consists of the following services and components.

#### Data sources

**On-premises SQL Server**. The source data is located in a SQL Server database on premises. To simulate the on-premises environment, the deployment scripts for this architecture provision a virtual machine in Azure with SQL Server installed. The [Wide World Importers OLTP sample database][wwi] is used as the source database.

**External data**. A common scenario for data warehouses is to integrate multiple data sources. This reference architecture loads an external data set that contains city populations by year, and integrates it with the data from the OLTP database. You can use this data for insights such as: "Does sales growth in each region match or exceed population growth?"

#### Ingestion and data storage

**Blob Storage**. Blob storage is used as a staging area for the source data before loading it into Azure Synapse.

**Azure Synapse**. [Azure Synapse](/azure/sql-data-warehouse/) is a distributed system designed to perform analytics on large data. It supports massive parallel processing (MPP), which makes it suitable for running high-performance analytics.

**Azure Data Factory**. [Data Factory][adf] is a managed service that orchestrates and automates data movement and data transformation. In this architecture, it coordinates the various stages of the ELT process.

#### Analysis and reporting

**Azure Analysis Services**. [Analysis Services](/azure/analysis-services/) is a fully managed service that provides data modeling capabilities. The semantic model is loaded into Analysis Services.

**Power BI**. Power BI is a suite of business analytics tools to analyze data for business insights. In this architecture, it queries the semantic model stored in Analysis Services.

#### Authentication

**Azure Active Directory** (Azure AD) authenticates users who connect to the Analysis Services server through Power BI.

Data Factory can also use Azure AD to authenticate to Azure Synapse, by using a service principal or Managed Service Identity (MSI). For simplicity, the example deployment uses SQL Server authentication.

### Components

- [Azure Blob Storage](https://azure.microsoft.com/products/storage/blobs)
- [Azure Synapse Analytics](https://azure.microsoft.com/products/synapse-analytics/#overview)
- [Azure Data Factory](https://azure.microsoft.com/products/data-factory)
- [Azure Analysis Services](https://azure.microsoft.com/products/analysis-services)
- [Power BI](https://powerbi.microsoft.com)
- [Azure Active Directory](https://azure.microsoft.com/products/active-directory)

## Scenario details

### Data pipeline

In [Azure Data Factory][adf], a pipeline is a logical grouping of activities used to coordinate a task &mdash; in this case, loading and transforming data into Azure Synapse.

This reference architecture defines a parent pipeline that runs a sequence of child pipelines. Each child pipeline loads data into one or more data warehouse tables.

![Screenshot of the pipeline in Azure Data Factory.](./images/adf-pipeline.png)

## Recommendations

### Incremental loading

When you run an automated ETL or ELT process, it's most efficient to load only the data that changed since the previous run. This is called an *incremental load*, as opposed to a full load that loads all the data. To perform an incremental load, you need a way to identify which data has changed. The most common approach is to use a *high water mark* value, which means tracking the latest value of some column in the source table, either a datetime column or a unique integer column.

Starting with SQL Server 2016, you can use [temporal tables](/sql/relational-databases/tables/temporal-tables). These are system-versioned tables that keep a full history of data changes. The database engine automatically records the history of every change in a separate history table. You can query the historical data by adding a FOR SYSTEM_TIME clause to a query. Internally, the database engine queries the history table, but this is transparent to the application.

> [!NOTE]
> For earlier versions of SQL Server, you can use [Change Data Capture](/sql/relational-databases/track-changes/about-change-data-capture-sql-server) (CDC). This approach is less convenient than temporal tables, because you have to query a separate change table, and changes are tracked by a log sequence number, rather than a timestamp.
>

Temporal tables are useful for dimension data, which can change over time. Fact tables usually represent an immutable transaction such as a sale, in which case keeping the system version history doesn't make sense. Instead, transactions usually have a column that represents the transaction date, which can be used as the watermark value. For example, in the Wide World Importers OLTP database, the Sales.Invoices and Sales.InvoiceLines tables have a `LastEditedWhen` field that defaults to `sysdatetime()`.

Here is the general flow for the ELT pipeline:

1. For each table in the source database, track the cutoff time when the last ELT job ran. Store this information in the data warehouse. (On initial setup, all times are set to '1-1-1900'.)

2. During the data export step, the cutoff time is passed as a parameter to a set of stored procedures in the source database. These stored procedures query for any records that were changed or created after the cutoff time. For the Sales fact table, the `LastEditedWhen` column is used. For the dimension data, system-versioned temporal tables are used.

3. When the data migration is complete, update the table that stores the cutoff times.

It's also useful to record a *lineage* for each ELT run. For a given record, the lineage associates that record with the ELT run that produced the data. For each ETL run, a new lineage record is created for every table, showing the starting and ending load times. The lineage keys for each record are stored in the dimension and fact tables.

![Screenshot of the city dimension table](./images/city-dimension-table.png)

After a new batch of data is loaded into the warehouse, refresh the Analysis Services tabular model. See [Asynchronous refresh with the REST API](/azure/analysis-services/analysis-services-async-refresh).

### Data cleansing

Data cleansing should be part of the ELT process. In this reference architecture, one source of bad data is the city population table, where some cities have zero population, perhaps because no data was available. During processing, the ELT pipeline removes those cities from the city population table. Perform data cleansing on staging tables, rather than external tables.

Here is the stored procedure that removes the cities with zero population from the City Population table. (You can find the source file [here](https://github.com/mspnp/azure-data-factory-sqldw-elt-pipeline/blob/master/azure/sqldw_scripts/citypopulation/%5BIntegration%5D.%5BMigrateExternalCityPopulationData%5D.sql).)

```sql
DELETE FROM [Integration].[CityPopulation_Staging]
WHERE RowNumber in (SELECT DISTINCT RowNumber
FROM [Integration].[CityPopulation_Staging]
WHERE POPULATION = 0
GROUP BY RowNumber
HAVING COUNT(RowNumber) = 4)
```

### External data sources

Data warehouses often consolidate data from multiple sources. This reference architecture loads an external data source that contains demographics data. This dataset is available in Azure blob storage as part of the [WorldWideImportersDW](https://github.com/microsoft/sql-server-samples/tree/master/samples/databases/wide-world-importers/sample-scripts/load-sample-data-using-polybase) sample.

Azure Data Factory can copy directly from blob storage, using the [blob storage connector](/azure/data-factory/connector-azure-blob-storage). However, the connector requires a connection string or a shared access signature, so it can't be used to copy a blob with public read access. As a workaround, you can use PolyBase to create an external table over Blob storage and then copy the external tables into Azure Synapse.

### Handling large binary data

In the source database, the Cities table has a Location column that holds a [geography](/sql/t-sql/spatial-geography/spatial-types-geography) spatial data type. Azure Synapse doesn't support the **geography** type natively, so this field is converted to a **varbinary** type during loading. (See [Workarounds for unsupported data types](/azure/sql-data-warehouse/sql-data-warehouse-tables-data-types#unsupported-data-types).)

However, PolyBase supports a maximum column size of `varbinary(8000)`, which means some data could be truncated. A workaround for this problem is to break the data up into chunks during export, and then reassemble the chunks, as follows:

1. Create a temporary staging table for the Location column.

2. For each city, split the location data into 8000-byte chunks, resulting in 1 &ndash; N rows for each city.

3. To reassemble the chunks, use the T-SQL [PIVOT](/sql/t-sql/queries/from-using-pivot-and-unpivot) operator to convert rows into columns and then concatenate the column values for each city.

The challenge is that each city will be split into a different number of rows, depending on the size of geography data. For the PIVOT operator to work, every city must have the same number of rows. To make this work, the T-SQL query (which you can view [here][MergeLocation]) does some tricks to pad out the rows with blank values, so that every city has the same number of columns after the pivot. The resulting query turns out to be much faster than looping through the rows one at a time.

The same approach is used for image data.

### Slowly changing dimensions

Dimension data is relatively static, but it can change. For example, a product might get reassigned to a different product category. There are several approaches to handling slowly changing dimensions. A common technique, called [Type 2](https://wikipedia.org/wiki/Slowly_changing_dimension#Type_2:_add_new_row), is to add a new record whenever a dimension changes.

In order to implement the Type 2 approach, dimension tables need additional columns that specify the effective date range for a given record. Also, primary keys from the source database will be duplicated, so the dimension table must have an artificial primary key.

The following image shows the Dimension.City table. The `WWI City ID` column is the primary key from the source database. The `City Key` column is an artificial key generated during the ETL pipeline. Also notice that the table has `Valid From` and `Valid To` columns, which define the range when each row was valid. Current values have a `Valid To` equal to '9999-12-31'.

![Screenshot of the city dimension table](./images/city-dimension-table.png)

The advantage of this approach is that it preserves historical data, which can be valuable for analysis. However, it also means there will be multiple rows for the same entity. For example, here are the records that match `WWI City ID` = 28561:

![Second screenshot of the city dimension table](./images/city-dimension-table-2.png)

For each Sales fact, you want to associate that fact with a single row in City dimension table, corresponding to the invoice date.

The following T-SQL query creates a temporary table that associates each invoice with the correct City Key from the City dimension table.

```sql
CREATE TABLE CityHolder
WITH (HEAP , DISTRIBUTION = HASH([WWI Invoice ID]))
AS
SELECT DISTINCT s1.[WWI Invoice ID] AS [WWI Invoice ID],
                c.[City Key] AS [City Key]
    FROM [Integration].[Sale_Staging] s1
    CROSS APPLY (
                SELECT TOP 1 [City Key]
                    FROM [Dimension].[City]
                WHERE [WWI City ID] = s1.[WWI City ID]
                    AND s1.[Last Modified When] > [Valid From]
                    AND s1.[Last Modified When] <= [Valid To]
                ORDER BY [Valid From], [City Key] DESC
                ) c

```

This table is used to populate a column in the Sales fact table:

```sql
UPDATE [Integration].[Sale_Staging]
SET [Integration].[Sale_Staging].[WWI Customer ID] =  CustomerHolder.[WWI Customer ID]
```

This column enables a Power BI query to find the correct City record for a given sales invoice.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

## Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

For additional security, you can use [Virtual Network service endpoints](/azure/virtual-network/virtual-network-service-endpoints-overview) to secure Azure service resources to only your virtual network. This fully removes public Internet access to those resources, allowing traffic only from your virtual network.

With this approach, you create a VNet in Azure and then create private service endpoints for Azure services. Those services are then restricted to traffic from that virtual network. You can also reach them from your on-premises network through a gateway.

Be aware of the following limitations:

- If service endpoints are enabled for Azure Storage, PolyBase cannot copy data from Storage into Azure Synapse. There is a mitigation for this issue. For more information, see [Impact of using VNet Service Endpoints with Azure storage](/azure/sql-database/sql-database-vnet-service-endpoint-rule-overview?toc=%2fazure%2fvirtual-network%2ftoc.json#impact-of-using-vnet-service-endpoints-with-azure-storage).

- To move data from on-premises into Azure Storage, you will need to allow public IP addresses from your on-premises or ExpressRoute. For details, see [Securing Azure services to virtual networks](/azure/virtual-network/virtual-network-service-endpoints-overview#secure-azure-services-to-virtual-networks).

- To enable Analysis Services to read data from Azure Synapse, deploy a Windows VM to the virtual network that contains the Azure Synapse service endpoint. Install [Azure On-premises Data Gateway](/azure/analysis-services/analysis-services-gateway) on this VM. Then connect your Azure Analysis service to the data gateway.

### DevOps

- Create separate resource groups for production, development, and test environments. Separate resource groups make it easier to manage deployments, delete test deployments, and assign access rights.

- Use the [Azure Building blocks][azbb] templates provided in this architecture or create [Azure Resource Manager template][arm-template] to deploy the Azure resources following the infrastructure as Code (IaC) Process. With templates,  automating deployments using [Azure DevOps Services][az-devops], or other CI/CD solutions is easier.

- Put each workload in a separate deployment template and store the resources in source control systems. You can deploy the templates together or individually as part of a CI/CD process, making the automation process easier.

    In this architecture, there are three main workloads:
    - The data warehouse server, Analysis Services, and related resources.
    - Azure Data Factory.
    - An on-premises to cloud simulated scenario.

    Each workload has its own deployment template.

    The data warehouse server is set up and configured by using Azure CLI commands which follows the imperative approach of the IaC practice. Consider using deployment scripts and integrate them in the automation process.

- Consider staging your workloads. Deploy to various stages and run validation checks at each stage before moving to the next stage. That way you can push updates to your production environments in a highly controlled way and minimize unanticipated deployment issues. Use [Blue-green deployment][blue-green-dep] and [Canary releases][cannary-releases]  strategies for updating live production environments.

    Have a good rollback strategy for handling failed deployments. For example, you can automatically redeploy an earlier, successful deployment from your deployment history. See the --rollback-on-error flag parameter in Azure CLI.

- [Azure Monitor][azure-monitor] is the recommended option for analyzing the performance of your data warehouse and the entire Azure analytics platform for an integrated monitoring experience. [Azure Synapse Analytics][synapse-analytics] provides a monitoring experience within the Azure portal to show insights to your data warehouse workload. The Azure portal is the recommended tool when monitoring your data warehouse because it provides configurable retention periods, alerts, recommendations, and customizable charts and dashboards for metrics and logs.

For more information, see the DevOps section in [Microsoft Azure Well-Architected Framework][AAF-devops].

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Use the [Azure pricing calculator][azure-pricing-calculator] to estimate costs. Here are some considerations for services used in this reference architecture.

#### Azure Data Factory

In this architecture, Azure Data Factory automates the ELT pipeline. The pipeline moves the data from an on-premises SQL Server database into Azure Synapse. The data is then transformed into a tabular model for analysis. For this scenario, pricing starts from $ 0.001 activity runs per month that includes activity, trigger, and debug runs. That price is the base charge only for orchestration. You are also charged for execution activities, such as copying data, lookups, and external activities. Each activity is individually priced. You are also charged for pipelines with no associated triggers or runs within the month. All activities are prorated by the minute and rounded up.

##### Example cost analysis

Consider a use case where there are two lookups activities from two different sources. One takes 1 minute and 2 seconds (rounded up to 2 minutes) and the other one takes 1 minute resulting in total time of 3 minutes. One data copy activity takes 10 minutes. One stored procedure activity takes 2 minutes. Total activity runs for 4 minutes. Cost is calculated as follows:

Activity runs: 4 * $ 0.001 = $0.004

Lookups: 3 * ($0.005 / 60) = $0.00025

Stored procedure: 2 * ($0.00025 / 60) = $0.000008

Data copy: 10 * ($0.25 / 60) * 4 data integration unit (DIU) = $0.167

- Total cost per pipeline run: $0.17.
- Run once per day for 30 days: $5.1 month.
- Run once per day per 100 tables for 30 days: $ 510

Every activity has an associated cost. Understand the pricing model and use the [ADF pricing calculator][adf-calculator] to get a solution optimized not only for performance but also for cost. Manage your costs by starting, stopping, pausing, and scaling your services.

#### Azure Synapse

Azure Synapse is ideal for intensive workloads with higher query performance and compute scalability needs. You can choose the pay-as-you-go model or use reserved plans of one year (37% savings) or 3 years (65% savings).

Data storage is charged separately. Other services such as disaster recovery and threat detection are also charged separately.

For more information, see [Azure Synapse Pricing][az-synapse-pricing].

#### Analysis Services

Pricing for Azure Analysis Services depends on the tier. The reference implementation of this architecture uses the **Developer** tier, which is recommended for evaluation, development, and test scenarios. Other tiers include, the **Basic** tier, which is recommended for small production environment; the **Standard** tier for mission-critical production applications. For more information, see [The right tier when you need it](/azure/analysis-services/analysis-services-overview#the-right-tier-when-you-need-it).

No charges apply when you pause your instance.

For more information, see [Azure Analysis Services pricing][az-as-pricing].

#### Blob Storage

Consider using the Azure Storage reserved capacity feature to lower cost on storage. With this model, you get a discount if you can commit to reservation for fixed storage capacity for one or three years. For more information, see [Optimize costs for Blob storage with reserved capacity][az-storage-reserved].

For more information, see the Cost section in [Microsoft Azure Well-Architected Framework][aaf-cost].

## Deploy this scenario

To the deploy and run the reference implementation, follow the steps in the [GitHub readme][github]. It deploys the following:

- A Windows VM to simulate an on-premises database server. It includes SQL Server 2017 and related tools, along with Power BI Desktop.
- An Azure storage account that provides Blob storage to hold data exported from the SQL Server database.
- An Azure Synapse instance.
- An Azure Analysis Services instance.
- Azure Data Factory and the Data Factory pipeline for the ELT job.

## Next steps

- [Introduction to Azure Synapse Analytics](/training/modules/introduction-azure-synapse-analytics)
- [Get Started with Azure Synapse Analytics](/azure/synapse-analytics/get-started)
- [Introduction to Azure Data Factory](/training/modules/intro-to-azure-data-factory)
- [What is Azure Data Factory?](/azure/data-factory/introduction)
- [Azure Data Factory tutorials](/azure/data-factory/data-factory-tutorials)

## Related resources

You may want to review the following [Azure example scenarios](/azure/architecture/example-scenario) that demonstrate specific solutions using some of the same technologies:

- [Data warehousing and analytics for sales and marketing](../../example-scenario/data/data-warehouse.yml)
- [Hybrid ETL with existing on-premises SSIS and Azure Data Factory](../../example-scenario/data/hybrid-etl-with-adf.yml)
- [Enterprise BI in Azure with Azure Synapse](/azure/architecture/example-scenario/analytics/enterprise-bi-synapse).

<!-- links -->

[AAF-devops]: /azure/architecture/framework/devops/overview
[adf]: /azure/data-factory
[arm-template]: /azure/azure-resource-manager/resource-group-overview#resource-groups
[az-devops]: /azure/virtual-machines/windows/infrastructure-automation#azure-devops-services
[azbb]: https://github.com/mspnp/template-building-blocks/wiki
[azure-monitor]: https://azure.microsoft.com/services/monitor
[blue-green-dep]: https://martinfowler.com/bliki/BlueGreenDeployment.html
[cannary-releases]: https://martinfowler.com/bliki/CanaryRelease.html
[github]: https://github.com/mspnp/azure-data-factory-sqldw-elt-pipeline
[MergeLocation]: https://github.com/mspnp/azure-data-factory-sqldw-elt-pipeline/blob/master/azure/sqldw_scripts/city/%5BIntegration%5D.%5BMergeLocation%5D.sql
[synapse-analytics]: /azure/sql-data-warehouse/sql-data-warehouse-concept-resource-utilization-query-activity
[wwi]: /sql/sample/world-wide-importers/wide-world-importers-oltp-database
[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator
[aaf-cost]: /azure/architecture/framework/cost/overview
[adf]: /azure/data-factory
[adf-calculator]: https://azure.microsoft.com/pricing/calculator/?service=data-factory
[az-as-pricing]: https://azure.microsoft.com/pricing/details/analysis-services
[az-storage-reserved]: /azure/storage/blobs/storage-blob-reserved-capacity
[az-synapse-pricing]: https://azure.microsoft.com/pricing/details/synapse-analytics
[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator
[github]: https://github.com/mspnp/azure-data-factory-sqldw-elt-pipeline
[MergeLocation]: https://github.com/mspnp/azure-data-factory-sqldw-elt-pipeline/blob/master/azure/sqldw_scripts/city/%5BIntegration%5D.%5BMergeLocation%5D.sql
[wwi]: /sql/sample/world-wide-importers/wide-world-importers-oltp-database
