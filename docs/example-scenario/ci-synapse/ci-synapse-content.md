Dynamics Customer Insights (CI) can create a 360-degree customer view by unifying data from transactional, behavioral, and observational sources. This 360-degree customer view can then be made available inside enterprise data lakes and/or data warehouses as a golden customer dimension. Below you can see an example of gold customer records produced by CI's data unification process that takes customer data from multiple source systems to clean and merge them. In addition to core customer attributes, CI can also enrich the customer records with attributes like churn scores and brand affinities as seen in the example below.

![Architecture Diagram](customerdimensionexample.png?raw=true "Example of customer records")

![Architecture Diagram](customerbrandaffinityexample.png?raw=true "Example of customer records with brand affinity attributes")

This document discuss the dataflow, product integrations, and configurations available to build an enhanced customer dimension that can be consumed by analytics platforms external to Dynamics and CI. [Audience Insights](https://dynamics.microsoft.com/ai/customer-insights/audience-insights-capability/) is the feature of CI that offers the capabilities for unifying customer data sources and enhancing customer profiles. Please review these [Audience Insights main benefits](https://docs.microsoft.com/dynamics365/customer-insights/audience-insights/overview#main-benefits) for more information.

## Architecture

This high-level architecture depicts the flow of data from an organizations source systems (ERP, CRM, PoS, etc...) into a data lake on Azure. This same Azure data lake can be configured as the backend for Dynamics Customer Insights (CI). With a data lake backend, CI is able to load clean enhanced customer data into the data lake for consumption as a dimension by downstream data warehouses and apps.

Azure Synapse SQL Serverless is specifically called out for consumption of the enhanced CI customer data. Azure Synapse SQL Serverless introduces a cost-effective  design pattern known as the Logical Data Warehouse (LDW). The LDW pattern introduces an abstraction layer on top of external data stores, like data lakes, to provide familiar relation database constructs like tables and views. These tables and views can then be consumed by tools that support SQL Server endpoints. In the context of this example, Power BI can now source the enhanced CI customer data as a dimension table from a database using Azure Synapse SQL Serverless pools.

![Architecture Diagram](ci-synapse.png?raw=true "Architecture diagram depicting flow data from source system on the left to Power BI on the right, using Azure Data Factory, Azure Data Lake, Customer Insights, and Azure Synapse SQL Serverless to build an enhanced customer dimension.")

### Data Flow

The data flows through the solution as follows:

1. Using Azure Data Factory or Azure Synapse Pipelines, establish [Linked Services](/azure/data-factory/concepts-linked-services) to source systems and data stores. Azure Data Factory and Azure Synapse Pipelines support [90+ connectors](/azure/data-factory/copy-activity-overview#supported-data-stores-and-formats) that also include generic protocols for data sources where a native connector is not available.  
  
2. Load data from source systems into Azure data lake with the [Copy Data tool](/azure/data-factory/quickstart-create-data-factory-copy-data-tool#start-the-copy-data-tool). Data landed in a data lake then needs to be transformed to fit a Common Data Model (CDM) schema. Azure Data Factory mapping data flows support sinking data in CDM format ([Common Data Model format in Azure Data Factory and Synapse Analytics](/azure/data-factory/format-common-data-model)).
  
3. Importing data into CI involves configuring a [Connection to a Common Data Model folder using an Azure Data Lake account](/dynamics365/customer-insights/audience-insights/connect-common-data-model). Once data is imported into CI, the disparate customer data can be processed by CI's [Data Unification process (Map, Match, and Merge)](/dynamics365/customer-insights/audience-insights/data-unification). Unified data can then be further enhanced in CI through [Data Enrichment](/dynamics365/customer-insights/audience-insights/enrichment-hub), [Data Segments](/dynamics365/customer-insights/audience-insights/segments), and [AI Predictions](/dynamics365/customer-insights/audience-insights/predictions-overview). 
  
4. In Customer Insights, an export of data needs to be configured that will load data back to the data lake. Please see [Set up the connection to Azure Data Lake Storage Gen2](/dynamics365/customer-insights/audience-insights/export-azure-data-lake-storage-gen2) for details.
  
5. [Create a Logical Data Warehouse](/azure/synapse-analytics/sql/tutorial-logical-data-warehouse) in the Azure Synapse Analytics workspace. Please review the [Synapse SQL Serverless pool best practices](/azure/synapse-analytics/sql/best-practices-serverless-sql-pool) to determine if additional transformation of the exported CI data is necessary and whether views are better suited then tables.
  
6. By now CI data residing in the data lake is exposed as logical SQL Server tables and views that can be easily consumed by Power BI. Please see the [Tutorial for Using serverless SQL pools with Power BI](/azure/synapse-analytics/sql/tutorial-connect-power-bi-desktop) for an example.

### Components

- [Audience Insights](https://docs.microsoft.com/dynamics365/customer-insights/audience-insights/overview) - The module of Customer Insights that provides unification of customer data sources and enrichments like segmentation, customer total lifetime value (CTLV), and customer churn score.
- [Azure Synapse Serverless SQL pools](https://docs.microsoft.com/azure/synapse-analytics/sql/on-demand-workspace-overview) - Used to query customer data in a data lake using a familiar T-SQL language and SQL Server endpoint.
- [Common Data Model](https://docs.microsoft.com/common-data-model/data-lake) - The data model used by Customer Insights for the customer entity that it produces.
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage/) - Scalable and cost-effective cloud storage that is support by Customer Insights as a target for exporting data.
- [Azure Data Factory](https://docs.microsoft.com/azure/data-factory/concepts-pipelines-activities) - Cloud scale data integration service for orchestrating data flow.

## Considerations

While the Logical Data Warehouse (LDW) pattern is suggested as a means of consuming the enhanced data from CI, using the data in the form of a gold customer dimension with other data warehouse patterns is also possible.

Data integration pipelines is an overlapping feature between Azure Data Factory and Azure Synapse Analytics. Please review the comparison doc for a [breakdown on feature parity between Azure Data Factory and Azure Synapse Integration Pipelines](/azure/synapse-analytics/data-integration/concepts-data-factory-differences).

## Next steps

Learn how to further develop this approach:

- [MS Learn: Unlock customer intent with Dynamics 365 Audience insights](/learn/paths/build-customer-insights/)

- [Tutorial: Explore and Analyze data lakes with serverless SQL pool](/azure/synapse-analytics/sql/tutorial-data-analyst)

- [Tutorial: Create Logical Data Warehouse with serverless SQL pool](/azure/synapse-analytics/sql/tutorial-logical-data-warehouse)

## Related resources

- [Get Started with Azure Synapse Analytics](/azure/synapse-analytics/get-started)

- [Customer Insights Overview](/dynamics365/customer-insights/overview)

- [Analyze data in a storage account](/azure/synapse-analytics/get-started-analyze-storage)

- [Integrate with pipelines](/azure/synapse-analytics/get-started-pipelines)