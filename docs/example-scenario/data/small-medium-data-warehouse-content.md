This article describes several ways that small and midsize-sized businesses (SMBs) can modernize legacy data stores and explore big data tools and capabilities without overextending current budgets and skill sets. These comprehensive data warehousing solutions seamlessly integrate with Azure Machine Learning, Azure AI services, Microsoft Power Platform, Microsoft Dynamics 365, and other Microsoft technologies. These solutions provide an easy entry point to the fully managed software as a service (SaaS) data platform on Microsoft Fabric that can expand as your needs grow.

SMBs that use on-premises SQL Server for data warehousing solutions under 500 GB might benefit from using this pattern. They use various tools for data ingestion into their data warehousing solution, including SQL Server Integration Services (SSIS), SQL Server Analysis Services (SSAS), SQL Server Reporting Services (SSRS), common SQL stored procedures, external extract, transform, load (ETL) and extract, load, transform (ELT) tools, SQL Server Agent jobs, and SQL snapshot replication. Data synchronization operations are typically snapshot-based, performed once a day, and don't have real-time reporting requirements.

## Simplified architecture

:::image type="content" source="media/small-medium-data-warehouse/simplified-architecture.svg" alt-text="Diagram that illustrates a simplified SMB architecture." lightbox="media/small-medium-data-warehouse/simplified-architecture.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/modern-data-warehouse-small-business.vsdx) of this architecture.*

A conceptual modernization opportunity involves transitioning the legacy data warehousing solution to a combination of Azure SQL Database, Azure SQL Managed Instance, and Fabric. This strategy ensures broad compatibility with traditional SQL Server and SQL client tools like SQL Server Management Studio (SSMS). It also provides lift-and-shift options for existing processes and requires minimal upskilling for the support team. This solution serves as an initial step toward comprehensive modernization, which enables the organization to fully adopt a lakehouse approach as the data warehouse expands and the team's skill set grows.

## Architecture

:::image type="content" source="media/small-medium-data-warehouse/small-medium-data-warehouse.svg" alt-text="Diagram that illustrates an expanded architecture that's designed to meet future needs." lightbox="media/small-medium-data-warehouse/small-medium-data-warehouse.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/modern-data-warehouse-small-business.vsdx) of this architecture.*

Legacy SMB data warehouses can contain several types of data:

- Unstructured data, like documents and graphics.

- Semi-structured data, such as logs, CSVs, JSON, and XML files.

- Structured relational data, including databases that use stored procedures for ETL and ELT activities.

### Dataflow

The following dataflow corresponds to the preceding diagram. It demonstrates the ingestion of the data type that you choose:

1. Fabric data pipelines or Azure Data Factory pipelines orchestrate the ingestion of transactional data into the data warehousing solution.

   - The pipelines orchestrate the flow of migrated or partially refactored legacy databases and SSIS packages into SQL Database and SQL Managed Instance. You can quickly implement this lift-and-shift approach, which ensures a seamless transition from an on-premises SQL solution to a future Fabric SaaS environment. You can modernize databases incrementally after the lift and shift.

   - The pipelines can pass unstructured, semi-structured, and structured data into Azure Data Lake Storage for centralized storage and analysis with other sources. Use this approach when fusing data provides more business benefit than replatforming the data.

1. Use Microsoft Dynamics 365 data sources to build centralized business intelligence (BI) dashboards on augmented datasets by using Fabric serverless analysis tools. You can bring the fused and processed data back into Dynamics and use it for further analysis within Fabric.

1. Real-time data from streaming sources can enter the system via Azure Event Hubs or other streaming solutions. For customers with real-time dashboard requirements, Fabric Real-Time Analytics can analyze this data immediately.

1. The data can be ingested into the centralized Fabric OneLake for further analysis, storage, and reporting by using Data Lake Storage shortcuts. This process enables in-place analysis and facilitates downstream consumption.

1. Serverless analysis tools, such as SQL Analytics endpoint and Fabric Spark capabilities, are available on demand inside Fabric and don't require any provisioned resources. Serverless analysis tools are ideal for:

   - ETL and ELT activities on OneLake data.

   - Serving gold layer of medallion architecture to Power BI reports via the DirectLake feature.

   - Improvised data science explorations in T-SQL format or Python.

   - Early prototyping for data warehouse entities.

Fabric is tightly integrated with potential consumers of your multisource datasets, including Power BI front-end reports, Machine Learning, Power Apps, Azure Logic Apps, Azure Functions, and Azure App Service web apps.

### Components

- [Fabric](/fabric/get-started/microsoft-fabric-overview) is an analytics service that combines data engineering, data warehousing, data science, and real-time data and BI capabilities. In this solution, [Fabric data engineering capabilities](/fabric/data-engineering/data-engineering-overview) provide a collaborative platform for data engineers, data scientists, data analysts, and BI professionals. This key component is powered by serverless compute engines and delivers business value by generating insights that are distributed to customers.

- [SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) and [SQL Managed Instance](/azure/well-architected/service-guides/azure-sql-managed-instance/reliability) are cloud-based relational database services. SQL Database and SQL Managed Instance use [SSMS](/sql/ssms/sql-server-management-studio-ssms) to develop and maintain legacy artifacts like stored procedures. In this solution, these services host the enterprise data warehouse and perform ETL and ELT activities by using stored procedures or external packages. SQL Database and SQL Managed Instance are platform as a service (PaaS) environments that you can use to meet high availability and disaster recovery requirements. Make sure to choose the SKU that meets your requirements. For more information, see [High availability for SQL Database](/azure/azure-sql/database/high-availability-sla) and [High availability for SQL Managed Instance](/azure/azure-sql/managed-instance/business-continuity-high-availability-disaster-recover-hadr-overview?view=azuresql).

- [SSMS](/sql/ssms/sql-server-management-studio-ssms) is an integrated environment for managing SQL infrastructure that you can use to develop and maintain legacy artifacts, such as stored procedures.

- [Event Hubs](/azure/well-architected/service-guides/event-hubs) is a real-time data streaming platform and event ingestion service. Event Hubs seamlessly integrates with Azure data services and can ingest data from anywhere.

### Alternatives

- You can use [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub) to replace or complement Event Hubs. Choose your solution based on the source of your streaming data and whether you need cloning and bidirectional communication with the reporting devices.

- You can use [Fabric data pipelines](/fabric/data-factory/activity-overview) instead of Data Factory pipelines for data integration. Your decision will depend on several factors. For more information, see [Getting from Azure Data Factory to Data Factory in Fabric](/fabric/data-factory/compare-fabric-data-factory-and-azure-data-factory).

- You can use [Fabric Warehouse](/fabric/data-warehouse/data-warehousing) instead of SQL Database or SQL Managed Instance to store enterprise data. This article prioritizes time to market for customers who want to modernize their data warehouses. For more information about data store options for Fabric, see [Fabric decision guide](https://learn.microsoft.com/fabric/get-started/decision-guide-data-store).

## Scenario details

When SMBs modernize their on-premises data warehouses for the cloud, they can either adopt big data tools for future scalability or use traditional SQL-based solutions for cost efficiency, ease of maintenance, and a smooth transition. A hybrid approach provides the best of both worlds and enables easy migration of existing data estates while using modern tools and AI capabilities. SMBs can keep their SQL-based data sources running in the cloud and modernize them as needed.

This article describes several strategies for SMBs to modernize legacy data stores and explore big data tools and capabilities without stretching current budgets and skill sets. These comprehensive Azure data warehousing solutions seamlessly integrate with Azure and Microsoft services, including AI services, Microsoft Dynamics 365, and Microsoft Power Platform.

### Potential use cases

- Migrate a traditional on-premises relational data warehouse that's less than 1 TB and uses SSIS packages to orchestrate stored procedures.

- Mesh existing Dynamics or Microsoft Power Platform [Dataverse](https://powerplatform.microsoft.com/dataverse) data with batched and real-time [Data Lake](https://azure.microsoft.com/solutions/data-lake) sources.

- Use innovative techniques to interact with centralized Azure Data Lake Storage Gen2 data. These techniques include serverless analysis, knowledge mining, data fusion between domains, and end-user data exploration, including Fabric Copilot.

- Set up e-Commerce companies to adopt a data warehouse to optimize their operations.

This solution isn't recommended for:

- A [greenfield deployment](https://wikipedia.org/wiki/Greenfield_project) of data warehouses.

- Migration of on-premises data warehouses that are larger than 1 TB or are projected to reach that size within a year.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) enables you to modify values to understand how your specific requirements affect costs. You can see a pricing sample for an SMB data warehousing scenario in the Azure pricing calculator.

- [SQL Database](https://azure.microsoft.com/pricing/details/azure-sql-database/single) pricing depends on the compute and service tiers that you choose and the number of vCores and database transaction units. The example describes a single database with provisioned compute and eight vCores and assumes that you need to run stored procedures in SQL Database.

- [Data Lake Storage Gen2](https://azure.microsoft.com/pricing/details/storage/data-lake/) pricing depends on the amount of data that you store and how often you use the data. The sample pricing covers 1 TB of data storage and other transactional assumptions. The 1 TB refers to the size of the data lake and not the size of the original legacy database.

- [Fabric](https://azure.microsoft.com/pricing/details/microsoft-fabric/) pricing depends on either the Fabric F capacity price or the Premium Per Person price. Serverless capabilities use CPU and memory from your purchased dedicated capacity.

- [Event Hubs](https://azure.microsoft.com/pricing/details/event-hubs/) pricing depends on the tier that you choose, the number of throughput units provisioned, and the ingress traffic received. The example assumes one throughput unit in the Standard tier handling over one million events per month.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Galina Polyakova](https://www.linkedin.com/in/galinagpolyakova/) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- For training content and labs, see [Data engineer learning paths](/training/roles/data-engineer).
- [Get started with Fabric](/training/fabric/).
- [Browse all courses, learning paths, and modules](/training/browse/?products=fabric&resource_type=module).
- [Create a single database](/azure/azure-sql/database/single-database-create-quickstart).
- [Create a SQL Managed Instance](/azure/azure-sql/managed-instance/instance-create-quickstart?view=azuresql&tabs=azure-portal).
- [Create a storage account to use with Data Lake Storage Gen2](/azure/storage/blobs/create-data-lake-storage-account).
- [Create an event hub by using the Azure portal](/azure/event-hubs/event-hubs-create).

## Related resources

- [Data lakes](../../data-guide/scenarios/data-lake.md)
- [Data warehousing and analytics](data-warehouse.yml)
- [Analytics end-to-end with Azure Synapse](../dataplate2e/data-platform-end-to-end.yml)
- [Enterprise business intelligence](../analytics/enterprise-bi-synapse.yml)
