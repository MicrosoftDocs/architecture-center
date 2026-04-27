[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article outlines an implementation plan to replicate and sync data during modernization to Azure. It describes technical aspects like data stores, tools, and services.

## Architecture

:::image type="complex" source="./images/sync-mainframe-data-with-azure.svg" alt-text="An architecture diagram that shows how to sync on-premises data and Azure databases data during mainframe modernization." border="false" lightbox="./images/sync-mainframe-data-with-azure.svg":::
   The diagram shows the flow of data from Db2 sources through Azure Data Factory pipelines to data storage, analytics, and BI services on Azure. The diagram has two areas, one for on-premises components and one for Azure components. The on-premises area has two rectangles. One rectangle pictures databases, such as Db2 zOS and Db2 LUW. An arrow points from these databases to the second rectangle, which lists integration tools. Arrows point from each integration tool to a component in the Azure section. Self-hosted integration runtime points to a box labeled "Dynamic pipeline." This box contains one parent pipeline and three child pipelines. An arrow points from these pipelines to a box that's labeled "Data storage, analytics, and BI." This box contains Azure services like Azure SQL Database, Azure Cosmos DB, and Azure Blob Storage. Dotted, double-sided arrows connect the dynamic pipeline pathway with Azure Data Lake Storage Gen2 and Azure Databricks. Arrows point from on-premises SQL Server integration services and non-Microsoft tools to the box labeled "Data storage, analytics, and BI" in the Azure section. The on-premises data gateway integration tool points to a data pipeline in Fabric Data Factory. An arrow points from this pipeline to the "Data storage, analytics, and BI" box.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/sync-mainframe-data-with-azure.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

Mainframe and midrange systems update on-premises application databases at regular intervals. To maintain consistency, this solution syncs the latest data with Azure databases. The sync process involves the following steps.

1. Azure Data Factory dynamic pipelines orchestrate activities that range from data extraction to data loading. You can schedule pipeline activities, start them manually, or trigger them automatically.

   Pipelines group the activities that perform tasks. To extract data, Azure Data Factory dynamically creates one pipeline for each on-premises table. You can then use a massively parallel implementation when you replicate data in Azure. You can also configure the solution to meet your requirements:

   - **Full replication:** You replicate the entire database and make the necessary modifications to data types and fields in the target Azure database.

   - **Partial, delta, or incremental replication:** You use watermark columns in source tables to sync the updated rows with Azure databases. These columns contain either a continuously incrementing key or a time stamp that indicates the table's last update.

    Azure Data Factory also uses pipelines for the following transformation tasks:

    - Data-type conversion
    - Data manipulation
    - Data formatting
    - Column derivation
    - Data flattening
    - Data sorting
    - Data filtering

1. On-premises databases like Db2 zOS, Db2 for i, and Db2 LUW store the application data.
1. A self-hosted integration runtime (IR) provides the environment that Azure Data Factory uses to run and dispatch activities.
1. Azure Data Lake Storage Gen2 and Azure Blob Storage stage the data. This step is sometimes required to transform and merge data from multiple sources.
1. For data preparation, Azure Data Factory uses Azure Databricks, custom activities, and pipeline dataflows to transform data quickly and effectively.
1. Azure Data Factory loads data into the following relational and nonrelational Azure databases:

   - Azure SQL
   - Azure Database for PostgreSQL
   - Azure Cosmos DB
   - Azure Data Lake Storage
   - Azure Database for MySQL

1. SQL Server Integration Services (SSIS) extracts, transforms, and loads data.
1. The on-premises data gateway is a locally installed Windows client application that acts as a bridge between your local on-premises data sources and Azure services.
1. A data pipeline in Microsoft Fabric is a logical grouping of activities that perform data ingestion from Db2 to Azure storage and databases.
1. If the solution requires near real-time replication, you can use non-Microsoft tools.

### Components

This section describes other tools that you can use during data modernization, synchronization, and integration.

#### Data integrators

- [Azure Data Factory](/azure/data-factory/introduction) is a hybrid data integration service. You can use this fully managed, serverless solution to create, schedule, and orchestrate extract, transform, and load (ETL) workflows and extract, load, and transform (ELT) workflows.

- [Microsoft Fabric](/fabric/fundamentals/microsoft-fabric-overview) is an enterprise analytics platform that accelerates time to insight across data engineering, data warehousing, data integration, real‑time analytics, and business intelligence. It is delivered as a SaaS solution and has centralized storage in OneLake. Microsoft Fabric combines the following technologies and services:

  - **SQL technologies for enterprise data warehousing** is available in [Fabric Data Warehouse](/fabric/data-warehouse/), a managed, transactional (ACID) warehouse on an open Delta format.
  
  - **Large‑scale data engineering and machine learning** is provided by [Data Engineering (Lakehouse + notebooks)](/fabric/data-engineering/lakehouse-overview) with built‑in Spark capabilities.

  - **Near real time** is addressed by [Real‑Time Intelligence](/fabric/real-time-intelligence/overview) with Eventhouse (KQL) and [Eventstreams](/fabric/real-time-intelligence/event-streams/overview).
  
  - **ETL/ELT workflows** are implemented with [Data Factory in Fabric](/fabric/data-factory/data-factory-overview), including [pipelines](/fabric/data-factory/pipeline-overview), Dataflows Gen2, and a broad set of [connectors](/fabric/data-factory/connector-overview) with hybrid/on‑premises gateway support.

  - Fabric has native integrations with Power BI and with Azure services such as Azure Cosmos DB and Azure Machine Learning.

- [SSIS](/sql/integration-services/sql-server-integration-services) is a platform for building enterprise-level data integration and transformation solutions. You can use SSIS to manage, replicate, cleanse, and mine data.

- [Azure Databricks](/azure/databricks/introduction/) is a data analytics platform. It's based on the Apache Spark open-source distributed processing system and is optimized for the Azure cloud platform. In an analytics workflow, Azure Databricks reads data from multiple sources and uses Spark to provide insights.

#### Data storage

- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) is part of the [Azure SQL](/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview?view=azuresql) family and is built for the cloud. This service provides the benefits of a fully managed and evergreen platform as a service (PaaS). SQL Database also provides AI-powered, automated features that optimize performance and durability. Serverless compute and [hyperscale storage options](/azure/azure-sql/database/service-tier-hyperscale?view=azuresql) automatically scale resources on demand.

- [Azure SQL Managed Instance](/azure/well-architected/service-guides/azure-sql-managed-instance/reliability) is part of the Azure SQL service portfolio. This intelligent and scalable cloud database service combines the broadest SQL Server engine compatibility with all the benefits of a fully managed and evergreen PaaS. Use SQL Managed Instance to modernize existing apps at scale.

- [SQL Server on Azure Virtual Machines](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview?view=azuresql) provides a way to lift and shift SQL Server workloads to the cloud with complete code compatibility. As part of the Azure SQL family, SQL Server on Azure Virtual Machines provides the combined performance, security, and analytics of SQL Server with the flexibility and hybrid connectivity of Azure. Use SQL Server on Azure Virtual Machines to migrate existing apps or build new apps. You can also access the latest SQL Server updates and releases, including SQL Server 2019.

- [Azure Database for PostgreSQL](/azure/well-architected/service-guides/postgresql) is a fully managed relational database service that's based on the community edition of the open-source [PostgreSQL](https://www.postgresql.org/) database engine. Use this service to focus on application innovation instead of database management. You can also scale your workload as needed.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a globally distributed, [multiple-model](/azure/cosmos-db/nosql/modeling-data) database. Use Azure Cosmos DB to ensure that your solutions can elastically and independently scale throughput and storage across any number of geographic regions. This fully managed NoSQL database service guarantees single-digit, millisecond latencies at the ninety-ninth percentile anywhere in the world.

- [Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) is a storage repository that holds a large amount of data in its native, raw format. Data lake stores are optimized for scaling to terabytes and petabytes of data. The data typically comes from multiple, heterogeneous sources and can be structured, semi-structured, or unstructured. [Data Lake Storage Gen2](/azure/databricks/connect/storage/azure-storage) combines Data Lake Storage Gen1 capabilities with Blob Storage. This next-generation data lake solution provides file system semantics, file-level security, and scale. It also provides the tiered storage, high availability, and disaster recovery capabilities of Blob Storage.

- [Azure Database for MySQL](/azure/well-architected/service-guides/azure-db-mysql-cost-optimization) is a fully managed relational database service that's based on the [community edition of the open-source MySQL database engine](https://www.mysql.com/products/community/).

#### Other tools

- [Microsoft Service for Distributed Relational Database Architecture (DRDA)](/host-integration-server/what-is-his#Data) is a component of [Host Integration Server](/host-integration-server/what-is-his). Microsoft Service for DRDA is an application server that DRDA Application Requester (AR) clients use. Examples of DRDA AR clients include IBM Db2 for z/OS and Db2 for i5/OS. These clients use the application server to convert Db2 SQL statements and run them on SQL Server.

- [SQL Server Migration Assistant for Db2](/sql/ssma/sql-server-migration-assistant) automates migration from Db2 to Microsoft database services. This tool runs on a virtual machine. It converts Db2 database objects into SQL Server database objects and creates those objects in SQL.

## Scenario details

Data availability and integrity are essential in mainframe and midrange modernization. [Data-first strategies](/azure/architecture/example-scenario/mainframe/modernize-mainframe-data-to-azure) help keep data intact and available during the migration to Azure. To prevent disruptions during modernization, sometimes you need to replicate data quickly or keep on-premises data in sync with Azure databases.

Specifically, this solution covers:

- Extraction: Connect to and extract data from a source database.

- Transformation:

  - Staging: Temporarily store data in its original format and prepare it for transformation.

  - Preparation: Transform and manipulate data by using mapping rules that meet target database requirements.

- Loading: Insert data into a target database.

### Potential use cases

Data replication and sync scenarios that can benefit from this solution include:

- Command Query Responsibility Segregation architectures that use Azure to service all inquire channels.

- Environments that test on-premises applications and rehosted or re-engineered applications in parallel.

- On-premises systems that have tightly coupled applications that require phased remediation or modernization.

- By integrating data from mainframe systems into modern analytics platforms, organizations can unlock valuable insights from historical and real-time transactional records.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Rodrigo Rodríguez](https://www.linkedin.com/in/rod2k10/) | Senior Cloud Solution Architect, AI & Quantum

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- Contact [Azure Data Engineering - On-premises Modernization][Email address for information on Azure Data Engineering On-premises Modernization] for more information.
- Read the [Migration guide](/data-migration/).

## Related resources

- [Azure data architecture guide](/azure/architecture/databases/)
- [Azure data platform end-to-end](/azure/architecture/example-scenario/data/greenfield-lakehouse-fabric)

[Email address for information on Azure Data Engineering On-premises Modernization]: mailto:datasqlninja@microsoft.com
