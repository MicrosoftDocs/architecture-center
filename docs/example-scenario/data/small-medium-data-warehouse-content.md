This example workload shows several ways that small businesses (SMBs) can modernize legacy data stores and explore big data tools and capabilities, without overextending current budgets and skillsets. These end-to-end Azure data warehousing solutions integrate easily with tools like Azure Machine Learning, Microsoft Power Platform, Microsoft Dynamics, and other Microsoft technologies.

## Architecture

:::image type="content" border="false" source="media/small-medium-data-warehouse/small-medium-data-warehouse.svg" alt-text="Diagram showing how legacy data can migrate and modernize with Azure Synapse, SQL Database, Data Lake Storage Gen2, and other services." lightbox="media/small-medium-data-warehouse/small-medium-data-warehouse.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/modern-data-warehouse-small-business.vsdx) of this architecture.*

Legacy SMB data warehouses might contain several types of data:

- Unstructured data, like documents and graphics
- Semi-structured data, such as logs, CSVs, JSON, and XML files
- Structured relational data, including databases that use stored procedures for extract-transform-load/extract-load-transform (ETL/ELT) activities

### Dataflow

The following dataflow demonstrates the ingestion of your chosen data type:

1. Azure Synapse Analytics pipelines ingest the legacy data warehouses into Azure.

   - The pipelines orchestrate the flow of migrated or partially refactored legacy databases and SSIS packages into Azure SQL Database. This lift-and-shift approach is fastest to implement, and offers a smooth transition from an on-premises SQL solution to an eventual Azure platform-as-a-service (PaaS). You can modernize databases incrementally after the lift and shift.

   - The pipelines can also pass unstructured, semi-structured, and structured data into Azure Data Lake Storage for centralized storage and analysis with other sources. Use this approach when fusing data provides more business benefit than simply replatforming the data.

1. Microsoft Dynamics data sources can be used to build centralized BI dashboards on augmented datasets using Synapse Serverless analysis tools. You can bring the fused, processed data back into Dynamics and Power BI for further analysis.

1. Real-time data from streaming sources can also enter the system via Azure Event Hubs. For customers with real-time dashboard requirements, Azure Stream Analytics can analyze this data immediately.

1. The data can also enter the centralized Data Lake for further analysis, storage, and reporting.

1. Serverless analysis tools are available in the Azure Synapse Analytics workspace. These tools use serverless SQL pool or Apache Spark compute capabilities to process the data in Data Lake Storage Gen2. Serverless pools are available on demand, and don't require any provisioned resources.

   Serverless pools are ideal for:
   - Ad hoc data science explorations in T-SQL format.
   - Early prototyping for data warehouse entities.
   - Defining views that consumers can use, for example in Power BI, for scenarios that can tolerate performance lag.

Azure Synapse is tightly integrated with potential consumers of your fused datasets, like Azure Machine Learning. Other consumers can include Power Apps,  Azure Logic Apps, Azure Functions apps, and Azure App Service web apps.

### Components

- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is an analytics service that combines data integration, enterprise data warehousing, and big data analytics. In this solution:

  - An [Azure Synapse Workspace](/azure/synapse-analytics/quickstart-create-workspace) promotes collaboration between data engineers, data scientists, data analysts, and business intelligence (BI) professionals.
  - [Azure Synapse pipelines](/azure/synapse-analytics/get-started-pipelines) orchestrate and ingest data into SQL Database and Data Lake Storage Gen2.
  - [Azure Synapse serverless SQL pools](/azure/synapse-analytics/get-started-analyze-sql-on-demand) analyze unstructured and semi-structured data in Data Lake Storage Gen2 on demand.
  - [Azure Synapse serverless Apache Spark pools](/azure/synapse-analytics/get-started-analyze-spark) do code-first explorations in Data Lake Storage Gen2 with Spark languages like Spark SQL, pySpark, and Scala.

- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database) is an intelligent, scalable, relational database service built for the cloud. In this solution, SQL Database holds the enterprise data warehouse and performs ETL/ELT activities that use stored procedures.

- [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs) is a real-time data streaming platform and event ingestion service. Event Hubs can ingest data from anywhere, and seamlessly integrates with Azure data services.

- [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics) is a real-time, serverless analytics service for streaming data. Stream Analytics offers rapid, elastic scalability, enterprise-grade reliability and recovery, and built-in machine learning capabilities.

- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) is a toolset for data science model development and lifecycle management. Machine Learning is one example of the Azure and Microsoft services that can consume fused, processed data from Data Lake Storage Gen2.

### Alternatives

- [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub) could replace or complement Event Hubs. The solution you choose depends on the source of your streaming data, and whether you need cloning and bidirectional communication with the reporting devices.

- You can use [Azure Data Factory](https://azure.microsoft.com/services/data-factory) for data integration instead of Azure Synapse pipelines. The choice depends on several factors:

  - Azure Synapse pipelines keep the solution design simpler, and allow collaboration inside a single Azure Synapse workspace.
  - Azure Synapse pipelines don't support SSIS packages rehosting, which is available in Azure Data Factory.
  - [Synapse Monitor Hub](/azure/synapse-analytics/get-started-monitor) monitors Azure Synapse pipelines, while [Azure Monitor](https://azure.microsoft.com/services/monitor) can monitor Data Factory.

  For more information and a feature comparison between Azure Synapse pipelines and Data Factory, see [Data integration in Azure Synapse Analytics versus Azure Data Factory](/azure/synapse-analytics/data-integration/concepts-data-factory-differences).

- You can use [Synapse Analytics dedicated SQL pools](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is) for storing enterprise data, instead of using SQL Database. Review the use cases and considerations in this article and related resources to make a decision.

## Scenario details

Small and medium businesses (SMBs) face a choice when modernizing their on-premises data warehouses for the cloud. They can adopt big data tools for future extensibility, or keep traditional, SQL-based solutions for cost efficiency, ease of maintenance, and smooth transition.

However, a hybrid approach combines easy migration of the existing data estate with the opportunity to add big data tools and processes for some use cases. SQL-based data sources can keep running in the cloud and continue to modernize as appropriate.

This example workload shows several ways that SMBs can modernize legacy data stores and explore big data tools and capabilities, without overextending current budgets and skillsets. These end-to-end Azure data warehousing solutions integrate easily with Azure and Microsoft services and tools like Azure Machine Learning, Microsoft Power Platform, and Microsoft Dynamics.

### Potential use cases

Several scenarios can benefit from this workload:

- Migrating a traditional, on-premises relational data warehouse that's smaller than 1 TB and extensively uses SQL Server Integration Services (SSIS) packages to orchestrate stored procedures.

- Meshing existing Dynamics or Power Platform [Dataverse](https://powerplatform.microsoft.com/dataverse) data with batched and real-time [Azure Data Lake](https://azure.microsoft.com/solutions/data-lake) sources.

- Using innovative techniques to interact with centralized Data Lake Storage Gen2 data. Techniques include serverless analysis, knowledge mining, data fusion between domains, and end-user data exploration.

- Setting up eCommerce companies to adopt a data warehouse to optimize their operations.

This solution isn't recommended for:

- [Greenfield](https://wikipedia.org/wiki/Greenfield_project) deployment of data warehouses that are estimated to be > 1 TB within one year.

- Migrating on-premises data warehouses that are > 1 TB or projected to grow to that size within a year.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

The following considerations apply to this scenario.

### Availability

SQL Database is a PaaS service that can meet your high availability (HA) and disaster recovery (DR) requirements. Be sure to pick the SKU that meets your requirements. For guidance, see [High availability for Azure SQL Database](/azure/azure-sql/database/high-availability-sla).

### Operations

SQL Database uses [SQL Server Management Studio (SSMS)](/sql/ssms/sql-server-management-studio-ssms) to develop and maintain legacy artifacts like stored procedures.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

See a [pricing sample for a SMB data warehousing scenario](https://azure.com/e/c0af42b09987434abec93f0131079984) in the Azure pricing calculator. Adjust the values to see how your requirements affect the costs.

- [SQL Database](https://azure.microsoft.com/pricing/details/azure-sql-database/single) bases costs on the selected Compute and Service tiers, and the number of vCores and Database Transaction Units (DTUs). The example shows a single database with provisioned Compute and eight vCores, based on the assumption that you need to run stored procedures in SQL Database.

- [Data Lake Storage Gen2](https://azure.microsoft.com/pricing/details/storage/data-lake/) pricing depends on the amount of data you store and how often you use the data. The sample pricing includes 1 TB of data stored, with further transactional assumptions. The 1 TB refers to the size of the data lake, not the original legacy database size.

- [Azure Synapse pipelines](https://azure.microsoft.com/pricing/details/synapse-analytics/#pricing) base costs on the number of data pipeline activities, integration runtime hours, data flow cluster size, and execution and operation charges. Pipeline costs increase with additional data sources and amounts of data processed. The example assumes one data source batched every hour for 15 minutes on an Azure-hosted integration runtime.

- [Azure Synapse Spark pool](https://azure.microsoft.com/pricing/details/synapse-analytics/#overview) bases pricing on node size, number of instances, and uptime. The example assumes one small compute node with five hours a week to 40 hours a month utilization.

- [Azure Synapse serverless SQL pool](https://azure.microsoft.com/pricing/details/synapse-analytics/#overview) bases pricing on TBs of data processed. The sample assumes 50 TBs processed a month. This figure refers to the size of the data lake, not the original legacy database size.

- [Event Hubs](https://azure.microsoft.com/pricing/details/event-hubs/) bills based on tier, throughput units provisioned, and ingress traffic received. The example assumes one throughput unit in Standard tier over one million events for a month.

- [Stream Analytics](https://azure.microsoft.com/pricing/details/stream-analytics/) bases costs on the number of provisioned streaming units. The sample assumes one streaming unit used over the month.

## Contributors

*This article is being updated and maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- Galina Polyakova | Senior Cloud Solution Architect

## Next steps

- For training content and labs, see the [Data Engineer Learning Paths](/training/roles/data-engineer).
- [Tutorial: Get started with Azure Synapse Analytics](/azure/synapse-analytics/get-started)
- [Create a single database - Azure SQL Database](/azure/azure-sql/database/single-database-create-quickstart)
- [Create a storage account for Azure Data Lake Storage Gen2](/azure/storage/blobs/create-data-lake-storage-account)
- [Azure Event Hubs Quickstart - Create an event hub using the Azure portal](/azure/event-hubs/event-hubs-create)
- [Quickstart - Create a Stream Analytics job by using the Azure portal](/azure/stream-analytics/stream-analytics-quick-create-portal)
- [Quickstart: Get started with Azure Machine Learning](/azure/machine-learning/quickstart-create-resources)

## Related resources

- For comprehensive architectural guidance on data pipelines, data warehousing, online analytical processing (OLAP), and big data, see the [Azure Data Architecture Guide](../../data-guide/index.md).
- Learn more about:
  - [Data lakes](../../data-guide/scenarios/data-lake.md)
  - [Data warehousing and analytics](data-warehouse.yml)
  - [Analytics end-to-end with Azure Synapse](../dataplate2e/data-platform-end-to-end.yml)
  - [Big data analytics with enterprise-grade security using Azure Synapse](../../solution-ideas/articles/big-data-analytics-enterprise-grade-security.yml)
  - [Enterprise business intelligence](/azure/architecture/example-scenario/analytics/enterprise-bi-synapse)