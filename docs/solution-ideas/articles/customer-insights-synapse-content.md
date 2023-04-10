[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This high-level architecture shows the flow of data from an organization's source systems (ERP, CRM, POS, and so on) into a data lake on Azure. This same data lake can be configured as the back end for Dynamics 365 Customer Insights. When it has a data lake back end, Customer Insights can load clean enhanced customer data into the data lake for consumption as a dimension by downstream data warehouses and apps.

## Architecture

:::image type="complex" border="false" source="../media/customer-insights-synapse.svg" alt-text="Diagram that shows a reference architecture for building an enhanced customer dimension.":::
   Architecture diagram that shows the flow of data from the source system on the left to Power BI on the right. The architecture uses Azure Data Factory, Azure Data Lake, Customer Insights, and Azure Synapse Analytics serverless SQL to build an enhanced customer dimension.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/customer-insights-synapse.vsdx) of this architecture.*

Azure Synapse serverless SQL consumes the enhanced Customer Insights data. Azure Synapse serverless SQL introduces a cost-effective design pattern known as Logical Data Warehouse (LDW). The LDW pattern introduces an abstraction layer on top of external data stores, like data lakes, to provide familiar relational database constructs like tables and views. Tools that support SQL Server endpoints can then consume these tables and views. In the context of this example, Power BI can source the enhanced Customer Insights data as a dimension table from a database by using Azure Synapse serverless SQL pools.

### Dataflow

1. By using Data Factory or Azure Synapse pipelines, establish [linked services](/azure/data-factory/concepts-linked-services) to source systems and data stores. Data Factory and Azure Synapse pipelines support [more than 90 connectors](/azure/data-factory/copy-activity-overview#supported-data-stores-and-formats), including generic protocols for data sources when a native connector isn't available.  
  
2. Load data from the source systems into Data Lake by using the [Copy Data tool](/azure/data-factory/quickstart-create-data-factory-copy-data-tool#start-the-copy-data-tool). You then need to transform data in the data lake to fit a Common Data Model schema. Data Factory mapping data flows support sinking data in the Common Data Model format. For more information, see [Common Data Model format in Azure Data Factory and Synapse Analytics](/azure/data-factory/format-common-data-model).
  
3. To import data into Customer Insights, you need to configure a [connection to a Common Data Model folder by using a Data Lake account](/dynamics365/customer-insights/audience-insights/connect-common-data-model). After you import data into Customer Insights, the Customer Insights [data unification process (map, match, and merge)](/dynamics365/customer-insights/audience-insights/data-unification) can process the disparate customer data. You can then further enrich unified data in Customer Insights by using [data enrichment](/dynamics365/customer-insights/audience-insights/enrichment-hub), [data segments](/dynamics365/customer-insights/audience-insights/segments), and [AI predictions](/dynamics365/customer-insights/audience-insights/predictions-overview). 
  
4. In Customer Insights, you need to configure an export of data back to the data lake. For more information, see [Set up the connection to Azure Data Lake Storage Gen2](/dynamics365/customer-insights/audience-insights/export-azure-data-lake-storage-gen2).
  
5. [Create a Logical Data Warehouse](/azure/synapse-analytics/sql/tutorial-logical-data-warehouse) in the Azure Synapse workspace. See the [Azure Synapse serverless SQL pool best practices](/azure/synapse-analytics/sql/best-practices-serverless-sql-pool) to determine whether you need to do more transformations on the exported Customer Insights data and whether views are better suited than tables.
  
6. Customer Insights data in the data lake is now exposed as logical SQL Server tables and views that can easily be consumed by Power BI. See [Tutorial for using serverless SQL pools with Power BI](/azure/synapse-analytics/sql/tutorial-connect-power-bi-desktop) for an example.

### Components

- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage). Scalable and cost-effective cloud storage that Customer Insights supports as a target for exporting data.
- [Azure Data Factory](https://azure.microsoft.com/en-us/services/data-factory). Cloud-scale data integration service for orchestrating data flow.
- [Audience insights](/dynamics365/customer-insights/audience-insights/overview). The Customer Insights module that unifies customer data sources. It also provides enrichments like segmentation, customer total lifetime value (CTLV), and customer churn score.
- [Azure Synapse serverless SQL pools](/azure/synapse-analytics/sql/on-demand-workspace-overview). Used to query customer data in a data lake via T-SQL and SQL Server endpoint.

### Alternatives

This solution uses the Logical Data Warehouse (LDW) pattern to consume the enhanced data from Customer Insights. You can also use other data warehouse patterns.

Data Factory and Azure Synapse both provide data integration pipelines. See the [breakdown of feature parity](/azure/synapse-analytics/data-integration/concepts-data-factory-differences) for a comparison.

## Scenario details

[Dynamics 365 Customer Insights](/dynamics365/customer-insights/overview) can create a 360-degree customer view by unifying data from transactional, behavioral, and observational sources. You can then make this 360-degree customer view available in enterprise data lakes and/or data warehouses as an enhanced customer [dimension](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-tables-overview#determine-table-category). 

This article describes the dataflow, product integrations, and configurations that are available for building an enhanced customer dimension that can be consumed by analytics platforms external to Dynamics 365 and Customer Insights. [Audience insights](https://dynamics.microsoft.com/ai/customer-insights/audience-insights-capability) is the feature of Customer Insights that provides the ability to unify customer data sources and enhance customer profiles. For more information, see [the audience insights overview](/dynamics365/customer-insights/audience-insights/overview?branch=master#main-benefits).

The following table shows an example of enhanced customer records that are produced by the Customer Insights data unification process. This process takes customer data from multiple source systems and cleans and merges it. Customer Insights can also enrich customer records with attributes like churn scores and brand affinities. Here are some fictional examples of this type of record:

:::image type="content" source="../media/customer-dimension-example.png" alt-text="Example customer records in a database table." lightbox="../media/customer-dimension-example.png":::

:::image type="content" source="../media/customer-brand-affinity-example.png" alt-text="Example of customer records with brand affinity attributes in a database table." :::

### Potential use cases

This architecture is applicable to any organization that needs to create records that draw data from multiple sources.

This solution is optimized for the retail industry.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Jon Dobrzeniecki](https://www.linkedin.com/in/jonathan-dobrzeniecki) | Cloud Solution Architect

## Next steps

- [Microsoft Learn: Unlock customer intent with Dynamics 365 audience insights](/training/paths/build-customer-insights)
- [Tutorial: Explore and analyze data lakes with serverless SQL pool](/azure/synapse-analytics/sql/tutorial-data-analyst)
- [Tutorial: Create a Logical Data Warehouse with serverless SQL pool](/azure/synapse-analytics/sql/tutorial-logical-data-warehouse)
- [Get started with Azure Synapse Analytics](/azure/synapse-analytics/get-started)
- [Customer Insights overview](/dynamics365/customer-insights/overview)
- [Analyze data in a storage account](/azure/synapse-analytics/get-started-analyze-storage)
- [Integrate activities by using pipelines](/azure/synapse-analytics/get-started-pipelines)

## Related resources

- [Get started with analytics architecture design](/azure/architecture/solution-ideas/articles/analytics-start-here)
- [Choose an analytical data store in Azure](/azure/architecture/data-guide/technology-choices/analytical-data-stores)
- [Analytics end-to-end with Azure Synapse](/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end)
