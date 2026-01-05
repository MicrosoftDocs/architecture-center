This article describes ways that small or medium-sized businesses can migrate and modernize legacy data stores within their current budgets and skill set. It shows how to progressively explore big data tools and capabilities. These data warehousing solutions integrate with Azure Machine Learning, Foundry Tools, Microsoft Power Platform, Dynamics 365, and other Microsoft technologies. These solutions provide an initial entry point to Microsoft Fabric, which is a managed software as a service (SaaS) data platform that can expand as your needs grow.

This pattern supports small or medium-sized businesses that have the following characteristics:

- Use on-premises SQL Server for data warehousing solutions under 1 terabyte (TB)

- Employ traditional SQL Server tools like SQL Server Integration Services (SSIS), SQL Server Analysis Services (SSAS), SQL Server Reporting Services (SSRS), common SQL stored procedures, and SQL Server Agent jobs

- Use external extract, transform, and load (ETL) and extract, load, and transform (ELT) tools

- Rely on snapshot replication for data synchronization

- Run batch-based operations and don't require real-time reporting

## Simplified architecture

:::image type="complex" source="media/small-medium-data-warehouse/simplified-architecture.svg" alt-text="Diagram that illustrates a simplified small or medium-sized business architecture." lightbox="media/small-medium-data-warehouse/simplified-architecture.svg" border="false":::
Diagram that shows a data flow for small or medium-sized business data warehousing modernization. On the left, a legacy data warehousing solution connects via a data pipeline arrow to a dotted box labeled Store and process. This box contains Azure SQL Database and SQL Managed Instance and connects to a second dotted box labeled Process and present. This box contains Fabric and connects to Power BI.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/modern-data-warehouse-small-business.vsdx) of this architecture.*

A conceptual modernization opportunity involves transitioning a legacy data warehousing solution to a combination of Azure SQL Database, Azure SQL Managed Instance, and Fabric. This strategy ensures broad compatibility with traditional SQL Server and SQL client tools like SQL Server Management Studio (SSMS). It also provides rehosting options for existing processes and requires minimal upskilling for the support team. This solution provides an initial step toward comprehensive modernization. As your data warehouse grows and your team gains expertise, you can progress to full SaaS warehousing on Fabric or adopt a lakehouse approach.

Legacy data warehouses for small or medium-sized businesses can contain several types of data:

- Unstructured data, like documents and graphics

- Semi-structured data, like logs, comma-separated values (CSV), JSON, and XML files

- Structured relational data, including databases that use stored procedures for ETL and ELT activities

## Architecture

:::image type="complex" source="media/small-medium-data-warehouse/small-medium-data-warehouse.svg" alt-text="Diagram that illustrates an expanded architecture designed to meet future needs." border="false":::
Diagram that shows a data flow architecture from left to right with multiple data sources, processing stages, and consumption endpoints. The left side shows three data source categories: stream sources, Dynamics 365, and unstructured data, semi-structured data, and relational databases. Four dotted sections go from left to right. The first section is labeled load and ingest and contains Event Hubs and a Data Factory pipeline. The second section is labeled store and contains Azure Data Lake Storage and SQL Database. The third section is labeled process and manipulate and contains Fabric Real-Time Intelligence and OneLake. The fourth section is labeled collaborate and consume and contains the SQL analytics endpoint, Apache Spark pool, and pipelines. The third and fourth sections reside in a Fabric environment labeled Fabric capacity, Premium capacity, or Premium Per User. Streaming sources point to Event Hubs (step 3). Unstructured data, semi-structured data, and relational databases point to the Data Factory pipeline. An arrow points from Event Hubs to Real-Time Intelligence. Arrows from Event Hubs, Dynamics 365 (step 2), and the Data Factory pipeline point to Data Lake Storage. An arrow from the Data Factory pipeline points to SQL Database (step 1). Data Lake Storage links to OneLake (step 4). An orange dotted box labeled serverless analysis contains Data Lake Storage, OneLake, and the SQL analytics endpoint (step 5). On the far right, a consume and serve section lists seven endpoints: Power Apps, Dynamics 365, Dynamics CRM, Power BI, Functions apps, Azure Logic Apps, and Web apps. Arrows point from each component in the collaborate and consume section to these endpoints.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/modern-data-warehouse-small-business.vsdx) of this architecture.*

### Data flow

The following data flow corresponds to the previous diagram:

1. Fabric data pipelines or Azure Data Factory pipelines ingest transactional data into the data warehousing solution.

   - The pipelines orchestrate the flow of migrated or partially refactored legacy databases and SSIS packages into SQL Database or SQL Managed Instance. This rehosting approach provides a transition from an on-premises SQL solution to a future Fabric SaaS environment. You can modernize databases incrementally after the initial migration.

   - The pipelines can move unstructured, semi-structured, and structured data into Azure Data Lake Storage for centralized storage and cross-source analysis. Use this approach when combining data from multiple sources provides more business value than migrating the data to a new platform.

1. Use Dynamics 365 data to build centralized business intelligence (BI) dashboards by using Fabric serverless analytics tools on enriched datasets. You can ingest Dynamics 365 data into Data Lake Storage or link your Dataverse environment directly to Fabric by using a Dynamics 365 shortcut in OneLake. You can write analytics results back to Dynamics 365 or continue analysis within Fabric.

1. Azure Event Hubs or other streaming solutions stream real-time data into the system. Fabric Real-Time Intelligence provides immediate analysis to support real-time dashboards.

1. Data Lake Storage shortcuts bring the data into Fabric OneLake for analysis, storage, and reporting. This approach analyzes data in place without moving it and makes it available to downstream consumers.

1. Fabric provides on-demand serverless analysis tools, like the SQL analytics endpoint and Apache Spark, without requiring provisioned resources. These tools support the following activities:

   - ETL and ELT activities on OneLake data

   - Serving gold layer of medallion architecture to Power BI reports via the DirectLake feature

   - Improvised data science explorations in T-SQL or Python

   - Early prototyping for data warehouse entities

Fabric integrates with consumers of your multisource datasets, including Power BI front-end reports, Machine Learning, Power Apps, Azure Logic Apps, Azure Functions, and Azure App Service web apps.

### Components

- [Fabric](/fabric/get-started/microsoft-fabric-overview) is an analytics service that combines data engineering, data warehousing, data science, and real-time data and BI capabilities. In this solution, [Fabric data engineering capabilities](/fabric/data-engineering/data-engineering-overview) provide a collaborative platform for data engineers, data scientists, data analysts, and BI professionals. Fabric uses serverless compute engines to generate insights that support business decision-making. 

- [SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) and [SQL Managed Instance](/azure/well-architected/service-guides/azure-sql-managed-instance/reliability) are cloud-based relational database services. In this architecture, these services host the enterprise data warehouse and perform ETL and ELT activities by using stored procedures or external packages (SSIS). SQL Database and SQL Managed Instance are platform as a service (PaaS) environments that you can use to meet high availability and disaster recovery requirements. Choose a SKU that meets your requirements. For more information, see [High availability for SQL Database](/azure/azure-sql/database/high-availability-sla) and [High availability for SQL Managed Instance](/azure/azure-sql/managed-instance/business-continuity-high-availability-disaster-recover-hadr-overview).

- [Event Hubs](/azure/well-architected/service-guides/event-hubs) is a real-time data streaming platform and event ingestion service. In this architecture, Event Hubs integrates with Azure data services to ingest streaming data from various sources into Data Lake Storage for analysis and reporting. Event Hubs can also stream data directly to Real-Time Intelligence.

- [Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) is a centralized cloud-based repository that stores structured and unstructured data. In this architecture, Data Lake Storage can store archived streaming data and copies of Dynamics 365 data.

### Alternatives

- You can use [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub) to replace or complement Event Hubs. Choose your solution based on the source of your streaming data and whether you need cloning and bidirectional communication with the reporting devices.

- You can use [Fabric data pipelines](/fabric/data-factory/activity-overview) instead of Data Factory pipelines for data integration. Your decision depends on several factors. For more information, see [Differences between Azure Data Factory and Fabric Data Factory](/fabric/data-factory/compare-fabric-data-factory-and-azure-data-factory).

- You can use [Fabric Data Warehouse](/fabric/data-warehouse/data-warehousing) instead of SQL Database or SQL Managed Instance to store enterprise data. This article prioritizes time to market for customers who want to modernize their data warehouses. For more information, see [Fabric data store options](/fabric/get-started/decision-guide-data-store).

## Scenario details

Small or medium-sized businesses that modernize on-premises data warehouses for the cloud can choose between two approaches. You can adopt big data tools for future scalability or use traditional SQL-based solutions for cost efficiency and a predictable transition. A hybrid approach lets you migrate existing data while using modern tools and AI capabilities. You can keep SQL-based data sources running in the cloud and modernize them incrementally.

This article describes strategies for small or medium-sized businesses to modernize legacy data stores and explore big data tools within existing budgets and skill set. These Azure data warehousing solutions integrate with Azure and Microsoft services, including Foundry Tools, Dynamics 365, and Power Platform.

### Potential use cases

- Migrate a traditional on-premises relational data warehouse that's less than 1 TB and uses SSIS packages to orchestrate stored procedures.

- Combine Dynamics 365 or [Dataverse](https://powerplatform.microsoft.com/dataverse) data with batch and real-time data from [Data Lake Storage](https://azure.microsoft.com/solutions/data-lake).

- Use innovative techniques to interact with centralized Data Lake Storage data. These techniques include serverless analysis, knowledge mining, data fusion between domains, and self-service data exploration by using Copilot in Fabric.

- Enable e-commerce businesses to adopt cloud data warehousing for operational optimization.

We don't recommend this solution for the following scenarios:

- Greenfield data warehouse deployments. For this scenario, see [Greenfield lakehouse on Fabric](/azure/architecture/example-scenario/data/greenfield-lakehouse-fabric).

- On-premises data warehouses that are 1 TB or larger, or that reach that size within a year. Most organizations adopt specialized data warehousing solutions for data warehouses this size. For these scenarios, see [Replatforming alternatives](#alternatives).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

You and Microsoft share responsibility for the reliability of most Azure services. Microsoft provides capabilities to support resiliency and recovery. You must understand how those capabilities work in each service that you use and select the configurations that meet your business objectives and uptime goals. Review service-specific documentation to select configurations that meet your business continuity and disaster recovery objectives.

- [SQL Managed Instance](/azure/reliability/reliability-sql-managed-instance) 
- [SQL Database](/azure/reliability/reliability-sql-database)
- [Azure Blob Storage](/azure/reliability/reliability-storage-blob)
- [Fabric](/azure/reliability/reliability-fabric)
- [Data Factory](/azure/reliability/reliability-data-factory)

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- The [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) lets you modify values to understand how your specific requirements affect costs. See a [pricing sample](https://azure.com/e/0ed01ef7a1e54b9bba6f252ca145ea13) for a small or medium-sized business data warehousing scenario.

- [SQL Database](https://azure.microsoft.com/pricing/details/azure-sql-database/single) pricing depends on the compute tier, service tier, number of vCores, and database transaction units. The pricing sample uses a single database with provisioned compute and eight vCores to run stored procedures in SQL Database. You can reduce costs by using reserved capacity and [Azure Hybrid Benefits](/azure/azure-sql/azure-hybrid-benefit).

- [Data Lake Storage](https://azure.microsoft.com/pricing/details/storage/data-lake/) pricing depends on storage volume and data access frequency. The pricing sample includes 1 TB of data storage and associated transaction costs. The 1 TB represents the data lake size, not the original legacy database size. Data Lake Storage is an extra modernization cost beyond the legacy database.

- [Fabric](https://azure.microsoft.com/pricing/details/microsoft-fabric/) pricing depends on the Fabric F capacity model or the Premium Per Person model. Serverless capabilities consume CPU and memory from your purchased dedicated capacity. After modernization, your existing reports continue to work by connecting to the new data warehouse (SQL Database or SQL Managed Instance) with your existing licensing. The pricing sample includes the F2 SKU to represent future BI expansion through self-service data preparation, datamarts, Real-Time Intelligence, and AI-assisted workflows. The F2 SKU with one-year reservation provides a cost-effective entry point. If you currently use Power BI Premium or migrated to F64, you might not need extra F capacity.

- [Event Hubs](https://azure.microsoft.com/pricing/details/event-hubs/) pricing depends on the selected tier, provisioned throughput units, and ingress traffic volume. The pricing sample assumes that one throughput unit in the Standard tier handles over one million events per month. Event Hubs represents an extra modernization cost if you add real-time streaming capabilities to your solution.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Galina Polyakova](https://www.linkedin.com/in/galinagpolyakova/) | Senior Cloud Solution Architect

Other contributor:

- [Bhaskar Sharma](https://www.linkedin.com/in/bhaskar-sharma-00991555/) | Senior Program Manager
  
*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Data engineer learning paths](/training/roles/data-engineer)
- [Get started with Fabric](/training/fabric/)
- [Browse all courses, learning paths, and modules for Fabric](/training/browse/?products=fabric&resource_type=module)
- [Create a single database](/azure/azure-sql/database/single-database-create-quickstart)
- [Create a deployment of SQL Managed Instance](/azure/azure-sql/managed-instance/instance-create-quickstart?view=azuresql&tabs=azure-portal)
- [Create a storage account to use with Data Lake Storage](/azure/storage/blobs/create-data-lake-storage-account)
- [Create an event hub by using the Azure portal](/azure/event-hubs/event-hubs-create)

## Related resources

- [Data lakes](../../data-guide/scenarios/data-lake.md)
- [Data warehousing and analytics](data-warehouse.yml)
- [Use Fabric to design an enterprise BI solution](../analytics/enterprise-bi-microsoft-fabric.yml)
