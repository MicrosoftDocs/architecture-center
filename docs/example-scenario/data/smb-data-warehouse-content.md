This example workload shows how small and medium businesses (SMBs) can modernize their legacy relational data warehouses, and explore big data tools and capabilities, without overextending their budgets and skillsets. This scenario also demonstrates how end-to-end Azure data warehousing solutions can integrate with data science, self-service business intelligence (BI), and the Microsoft Dynamics business suite.

SMBs that want to modernize their traditional on-premises data warehouses face a choice between adopting big data platform tools for future extensibility, versus keeping SQL-based solutions for cost efficiency, ease of maintenance, and smooth transition. A hybrid approach can offer easy migration of the existing data estate, with the opportunity to add big data platform tools and processes for some use cases. The existing platform can keep running as is, with the opportunity to modernize as appropriate.

## Potential use cases

There are several use cases for this solution:

- SMBs that want to migrate traditional on-premises data warehousing solutions to Azure. For example, an on-premises data warehouse that's smaller than 1 TB and uses SQL Server Integration Services (SSIS) packages extensively to orchestrate stored procedures.

- Microsoft Dynamics or Power Platform users who want to mesh their [Dataverse](https://powerplatform.microsoft.com/dataverse) data with batched and real-time [Azure Data Lake](https://azure.microsoft.com/solutions/data-lake) data sources.

- Organizations that want to use Azure Data Lake as a centralized storage place for all their data, so they can use innovative techniques to interact with the data. These techniques can include serverless analysis, knowledge mining, data fusion between domains, and data exploration for end users.

This solution isn't recommended for:

- [Greenfield](https://wikipedia.org/wiki/Greenfield_project) deployment of data warehouses that are estimated to be > 1TB within one year.

- Migrating on-premises data warehouses that are > 1 TB or projected to grow to that size within a year.

## Architecture

![Diagram showing how legacy data can migrate and modernize with Azure Synapse, SQL Database, Data Lake Storage, and other services.](media/smb-data-warehouse.svg)

1. Legacy SMB data warehouses may contain unstructured data, semi-structured data, and structured relational data that uses stored procedures for extract-transform-load/extract-load-transform (ETL/ELT) activities.
   
1. Azure Synapse Analytics pipelines ingest the legacy data warehouses into Azure SQL Database for centralized storage. The pipelines orchestrate the flow of the migrated or partially-refactored legacy SSIS packages into SQL Database.
   
   This approach is fastest to implement, and offers a smooth transition from an on-premises SQL solution to an eventual Azure platform-as-a-service (PaaS). There's an opportunity to modernize databases incrementally after the lift and shift.
   
1. Azure Synapse pipelines can also pass the data into Azure Data Lake Storage for centralized storage and analysis with other sources.
   
1. Real-time data from streaming sources can also enter the system via Azure Event Hubs. Azure Stream Analytics can analyze this data in real time, or it can enter the centralized Data Lake Storage for further analysis and storage.
   
1. You can use the data from the centralized Data Lake Storage for data science, real-time or historical reporting, or to connect to Dynamics and other services.

1. The serverless analysis section shows the big data platform tools that are available in the Azure Synapse Analytics workspace. These tools use serverless SQL pool or Apache Spark compute capabilities to process structured, semi-structured, or non-structured data that is stored in Data Lake Storage. Serverless SQL pools are available on demand, don't require any provisioned resources, and bill per TB of processed data.
   
   Serverless SQL pools are ideal for:
   - Ad-hoc data science explorations in T-SQL format.
   - Early prototyping for data warehouse entities.
   - Defining views that consumers can use, for example Power BI, in scenarios that can tolerate performance lag.
   
   This method is an easy way to mesh Dynamics data sources, or build centralized BI dashboards on augmented datasets. You can bring the processed data back into Dynamics, and share it with Power BI.

1. The diagram also shows the tight integration between Azure Synapse and other possible consumers of your fused datasets, like Azure Machine Learning.

## Components

- [Azure Event Hub](https://azure.microsoft.com/en-us/services/event-hubs) is a realtime data ingestion service.

- [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics) performs analytics for customers with real-time dashboard requirements.

- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database) is an intelligent, scalable, relational database service built for the cloud. In this solution, SQL Database holds the enterprise data warehouse and performs ETL/ELT activities that use stored procedures.

- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is an analytics service that combines data integration, enterprise data warehousing, and big data analytics. In this solution:

  - An [Azure Synapse Workspace](/azure/synapse-analytics/quickstart-create-workspace) promotes collaboration between data engineers, data scientists, data analysts, and BI professionals.
  - [Azure Synapse pipelines](/azure/synapse-analytics/get-started-pipelines) orchestrate and ingest data into SQL Database and Data Lake Storage.
  - [Azure Synapse serverless SQL pools](/azure/synapse-analytics/get-started-analyze-sql-on-demand) analyze unstructured and semi-structured data in Data Lake Storage on demand.
  - [Azure Synapse serverless Apache Spark pools](/azure/synapse-analytics/get-started-analyze-spark) do code-first explorations in Data Lake Storage with Spark languages like Spark SQL, pySpark, and Scala.

- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) is a toolset for data science model development and lifecycle management. In this example, Machine Learning represents the many services that can consume the fused, processed data.

## Alternatives

- [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub) could replace or complement Azure Event Hub, depending on the source of your unstructured data, and whether you need cloning and bidirectional communication with reporting devices.

- You can use [Azure Data Factory](https://azure.microsoft.com/services/data-factory) instead of Azure Synapse pipelines.
  
  - Azure Synapse pipelines keep the solution design simpler, and allow collaboration inside a single Azure Synapse workspace.
  - However, Azure Synapse pipelines don't support SSIS packages rehosting, which is available in Azure Data Factory.
  - [Synapse Monitor Hub](/azure/synapse-analytics/get-started-monitor) monitors Azure Synapse pipelines. [Azure Monitor](https://azure.microsoft.com/services/monitor) can monitor Data Factory.
  
  For more information and a feature comparison between Azure Synapse pipelines and Data Factory, see [Data integration in Azure Synapse Analytics versus Azure Data Factory](azure/synapse-analytics/data-integration/concepts-data-factory-differences).
  
- You can use [Synapse Analytics dedicated SQL pools](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is) for the enterprise data, instead of SQL Database. Review the use cases and considerations to make a decision.

## Considerations

The following considerations apply to this scenario:

### Availability

SQL Database is a PaaS service that can meet high availability (HA) and disaster recovery (DR) requirements. Be sure to pick the SKU that meets your requirements. For guidance, see [High availability for Azure SQL Database](/azure/azure-sql/database/high-availability-sla).

### Operations

In SQL Database, you use [SQL Server Management Studio (SSMS)](/sql/ssms/sql-server-management-studio-ssms) to develop and maintain legacy artifacts like stored procedures.

### Scalability

Serverless analysis with Azure Synapse SQL and Spark serverless pools means you can scale up computing resources based on demand.

## Pricing

See a [pricing sample for a SMB data warehousing scenario](https://azure.com/e/c0af42b09987434abec93f0131079984) via the Azure pricing calculator. Adjust the values to see how your requirements affect the costs.

- [SQL Database](https://azure.microsoft.com/pricing/details/azure-sql-database/single) costs are based on the selected Compute and Service tiers, and the number of vCores and Database Transaction Units (DTUs). The example shows a single database with provisioned Compute and eight vCores, based on the assumption that you need to run stored procedures there.

- [Azure Synapse pipeline](https://azure.microsoft.com/pricing/details/synapse-analytics/#pricing) costs are based on the number of data pipelines activities and integration runtime hours, data flow cluster size, and execution and operation charges. Pipeline costs increase with each additional data stream and the amount of data processed by each stream. The example assumes one data source batched every hour for 15 minutes on an Azure-hosted integration runtime.

- [Azure Synapse Spark pool](https://azure.microsoft.com/pricing/details/synapse-analytics/#overview) pricing is based on node size, number of instances, and uptime. The example assumes one small compute node with about five hours a week to 40 hours a month utilization.

- [Azure Synapse serverless SQL pool](https://azure.microsoft.com/pricing/details/synapse-analytics/#overview) pricing is based on TBs of data processed. The sample assumes 50 TB processed a month. This figure refers to the size of the data lake, not the original legacy database size.

- [Stream Analytics](https://azure.microsoft.com/pricing/details/stream-analytics/) bills based on the number of streaming units provisioned. The sample assumes one streaming unit used over the month.

- [Event Hubs](https://azure.microsoft.com/pricing/details/event-hubs/) bills based on tier, throughput units provisioned, and ingress traffic received. The example assumes one throughput unit in Standard tier over one million events for a month.

- [Data Lake Storage](https://azure.microsoft.com/pricing/details/storage/data-lake/) price depends on amount of data you store and how often you use the data. The sample pricing includes 1 TB of data, with further transactional assumptions. The 1 TB refers to the size of the data lake, not the original legacy database size.

## Next steps

- For training content and labs, see the Microsoft Learn [Data Engineer Learning Paths](/learn/roles/data-engineer).
- [Create a single database - Azure SQL Database](/azure/azure-sql/database/single-database-create-quickstart).
- [Tutorial: Get started with Azure Synapse Analytics](/azure/synapse-analytics/get-started).
- [Azure Event Hubs Quickstart - Create an event hub using the Azure portal](/azure/event-hubs/event-hubs-create).
- [Quickstart - Create a Stream Analytics job by using the Azure portal](/azure/stream-analytics/stream-analytics-quick-create-portal).
- [Quickstart: Get started with Azure Machine Learning](/azure/machine-learning/quickstart-create-resources).
- [Create a storage account for Azure Data Lake Storage](/azure/storage/blobs/create-data-lake-storage-account).

## Related resources

- For comprehensive architectural guidance on data pipelines, data warehousing, online analytical processing (OLAP), and big data, see the [Azure Data Architecture Guide](/azure/architecture/data-guide/).
- [Data lakes](/azure/architecture/data-guide/scenarios/data-lake).
- [Analytics end-to-end with Azure Synapse](/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end).
- [Big data analytics with enterprise-grade security using Azure Synapse](/azure/architecture/solution-ideas/articles/big-data-analytics-enterprise-grade-security)
- [Enterprise business intelligence](/azure/architecture/reference-architectures/data/enterprise-bi-synapse)
