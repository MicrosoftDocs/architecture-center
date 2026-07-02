[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article explains how to replicate and sync data to Azure during mainframe modernization. It describes the technical aspects of this solution idea, such as data stores, tools, and services. Mainframe and midrange systems update on-premises application databases at regular intervals. To maintain consistency, this solution syncs the latest data with Azure databases.

## Architecture

:::image type="complex" border="false" source="./images/sync-mainframe-data-with-azure.svg" alt-text="Diagram that shows the Replicate and Sync Mainframe Data to Azure architecture." lightbox="./images/sync-mainframe-data-with-azure.svg":::
   Diagram that shows the flow of data from Db2 sources through Azure Data Factory pipelines to data storage, analytics, and BI services on Azure. The diagram has one area for on-premises components and one area for Azure components. The on-premises area has two boxes. One box contains databases, such as Db2 zOS and Db2 LUW. An arrow points from these databases to the second box, which lists integration tools. Arrows point from each integration tool to a component in the Azure section. Self-hosted integration runtime points to the dynamic pipeline box, which contains one parent pipeline and three child pipelines. An arrow points from these pipelines to the data storage, analytics, and business intelligence (BI) box. This box contains Azure services like Azure SQL Database, Azure Cosmos DB, and Azure Blob Storage. Dotted, bidirectional arrows connect the dynamic pipeline pathway to Azure Data Lake Storage Gen2 and Azure Databricks. Arrows point from on-premises SQL Server Integration Services (SSIS) and non-Microsoft tools to the data storage, analytics, and BI box. The on-premises data gateway integration tool points to a data pipeline in Fabric Data Factory. An arrow points from this pipeline to the data storage, analytics, and BI box.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/sync-mainframe-data-with-azure.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. Azure Data Factory dynamic pipelines orchestrate activities, including data extraction and data loading. You can schedule pipeline activities, start them manually, or trigger them automatically.

   Pipelines group the activities that perform tasks. To extract data, Azure Data Factory dynamically creates one pipeline for each on-premises table. You can then use a massively parallel implementation when you replicate data in Azure. Configure the replication level based on your requirements.

   - **Full replication.** Replicate the entire database and modify data types and fields in the target Azure database.

   - **Partial, delta, or incremental replication.** Use watermark columns in source tables to sync the updated rows with Azure databases. These columns contain either a continuously incrementing key or a time stamp that indicates the table's last update.

    Azure Data Factory also uses pipelines for the following transformation tasks:

    - Data-type conversion

    - Data manipulation

    - Data formatting

    - Column derivation

    - Data flattening

    - Data sorting

    - Data filtering 

1. On-premises databases, like Db2 zOS, Db2 for i, and Db2 LUW, store the application data.

1. A self-hosted integration runtime (IR) provides the environment that Azure Data Factory uses to run and dispatch activities.

1. Azure Data Lake Storage Gen2 and Azure Blob Storage stage the data. This step might be required to transform and merge data from multiple sources.

1. For data preparation, Azure Data Factory uses Azure Databricks, custom activities, and pipeline dataflows to transform data quickly and effectively.

1. Azure Data Factory loads data into the following relational and nonrelational Azure databases:

   - Azure SQL

   - Azure Database for PostgreSQL

   - Azure Cosmos DB

   - Azure Data Lake Storage

   - Azure Database for MySQL

1. SQL Server Integration Services (SSIS) extracts, transforms, and loads data.

1. The on-premises data gateway is a local Windows client application that acts as a bridge between your local on-premises data sources and Azure services.

1. A Microsoft Fabric data pipeline is a logical grouping of activities that perform data ingestion from Db2 to Azure storage and databases.

1. If the solution requires near-real-time replication, you can use non-Microsoft tools.

If these tools can’t access the on-premises Db2 databases, extract the data and build a custom migration process to load the extracted files into the target databases.

### Components

This section describes other tools that you can use during data modernization, data synchronization, and data integration.

#### Data integrators

- [Azure Data Factory](/azure/data-factory/introduction) is a hybrid data integration service. You can use this fully managed, serverless solution to create, schedule, and orchestrate extract, transform, and load (ETL) workflows and extract, load, and transform (ELT) workflows.

- [Fabric](/fabric/fundamentals/microsoft-fabric-overview) is an enterprise analytics platform that accelerates time to insight across data engineering, data warehousing, data integration, real‑time analytics, and business intelligence. Fabric is a software as a service (SaaS) solution that uses centralized storage in OneLake. Fabric combines the following technologies and services:

  - **SQL technologies for enterprise data warehousing** are available by using [Fabric Data Warehouse](/fabric/data-warehouse/), which is a managed, transactional warehouse that uses an open Delta format.
  
  - **Large‑scale data engineering and machine learning** are available by using [Fabric Data Engineering](/fabric/data-engineering/lakehouse-overview), which includes built‑in Apache Spark capabilities.

  - **Near-real-time analytics** is available by using [Fabric Real‑Time Intelligence](/fabric/real-time-intelligence/overview), which includes eventhouses and [eventstreams](/fabric/real-time-intelligence/event-streams/overview).
  
  - **ETL and ELT workflows** are available by using [Fabric Data Factory](/fabric/data-factory/data-factory-overview), which includes [pipelines](/fabric/data-factory/pipeline-overview), Dataflow Gen2, and a range of [connectors](/fabric/data-factory/connector-overview) with hybrid and on‑premises gateway support.

  Fabric has native integrations with Power BI and with Azure services such as Azure Cosmos DB and Azure Machine Learning.

- [SSIS](/sql/integration-services/sql-server-integration-services) is a platform for enterprise-level data integration and transformation solutions. Use SSIS to manage, replicate, cleanse, and mine data.

- [Azure Databricks](/azure/well-architected/service-guides/azure-databricks) is a data analytics platform based on the Spark open-source distributed processing system. Azure Databricks is optimized for the Azure cloud platform. In an analytics workflow, Azure Databricks reads data from multiple sources and uses Spark to provide insights.

#### Data storage

- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database) is a fully managed, cloud-based platform as a service (PaaS). SQL Database provides AI-powered automated features that optimize performance and durability. Serverless compute and [Hyperscale storage options](/azure/azure-sql/database/service-tier-hyperscale) automatically scale resources on demand.

- [Azure SQL Managed Instance](/azure/well-architected/service-guides/azure-sql-managed-instance) is a fully managed, intelligent, and scalable cloud database service that has SQL Server engine compatibility. Use SQL Managed Instance to modernize existing apps at scale.

- [SQL Server on Azure Virtual Machines](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview) rehosts code-compatible SQL Server workloads in the cloud. SQL Server on Azure Virtual Machines combines the performance, security, and analytics of SQL Server with the flexibility and hybrid connectivity of Azure. To migrate existing apps or build new apps, use SQL Server on Azure Virtual Machines.

- [Azure Database for PostgreSQL](/azure/well-architected/service-guides/postgresql) is a fully managed relational database service based on the community edition of the open-source [PostgreSQL](https://www.postgresql.org) database engine. Azure Database for PostgreSQL provides scalable application innovation features. 

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a globally distributed, [multiple-model](/azure/cosmos-db/modeling-data) database. Use Azure Cosmos DB to ensure that your solutions can elastically and independently scale throughput and storage across multiple geographic regions.

- [Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) is a storage repository that holds large amounts of native and raw data. Data lake stores are optimized for scaling to terabytes and petabytes of data. The data typically comes from multiple heterogeneous sources and can be structured, semistructured, or unstructured. [Data Lake Storage Gen2](/azure/databricks/connect/storage/azure-storage) combines Data Lake Storage Gen1 capabilities with Blob Storage. Data Lake Storage Gen2 provides file system semantics, file-level security, and scale. It also provides the tiered storage, high availability, and disaster recovery capabilities of Blob Storage.

- [Azure Database for MySQL](/azure/well-architected/service-guides/azure-database-for-mysql) is a fully managed relational database service based on the [community edition of the open-source MySQL database engine](https://www.mysql.com/products/community/).

#### Other tools

- [Microsoft Service for Distributed Relational Database Architecture (DRDA)](/host-integration-server/what-is-his#Data) is a component of [Host Integration Server](/host-integration-server/what-is-his). Microsoft Service for DRDA is an application server that DRDA application requester (AR) clients use. Examples of DRDA AR clients include IBM Db2 for z/OS and Db2 for i5/OS. These clients use the application server to convert Db2 SQL statements and run them on SQL Server.

- [SQL Server Migration Assistant (SSMA) for Db2](/sql/ssma/sql-server-migration-assistant) automates migration from Db2 to Microsoft database services. The SSMA for Db2 tool runs on a virtual machine. It converts Db2 database objects into SQL Server database objects and creates those objects in SQL Server.

## Alternatives

This architecture shows options and Azure database targets for mainframe data replication and synchronization. You can also replicate and sync to the following Azure SQL targets:

- SQL Managed Instance is a fully managed cloud database service. SQL Managed Instance is compatible with SQL Server engine. Use SQL Managed Instance to modernize apps at scale.

- SQL Server on Azure Virtual Machines rehosts SQL Server workloads in the cloud without code changes. SQL Server on Azure Virtual Machines combines the performance, security, and analytics of SQL Server with the flexibility and hybrid connectivity of Azure. To migrate existing apps or to build new apps, use SQL Server on Azure Virtual Machines.

## Scenario details

Data availability and integrity are essential to mainframe and midrange modernization. [Data-first strategies](/azure/architecture/example-scenario/mainframe/modernize-mainframe-data-to-azure) help keep data intact and available during migration to Azure. To prevent disruptions during modernization, you might need to replicate data quickly or sync on-premises data with Azure databases.

This solution covers:

- **Extraction.** Connect to and extract data from a source database.

- **Transformation,** including:

  - **Staging:** Temporarily store data in its original format and prepare it for transformation.

  - **Preparation.** Transform and manipulate data by using mapping rules that meet target database requirements.

- **Loading.** Insert data into a target database.

### Potential use cases

Use this solution in the following data replication and sync scenarios:

- Command Query Responsibility Segregation architectures that use Azure to service all inquiry channels

- Environments that test on-premises applications and parallel rehosted or reengineered applications

- On-premises systems that use tightly coupled applications that require phased remediation or modernization

## Recommendations

You can apply the following recommendations to most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

If you use Azure Data Factory to extract data, [tune copy activity performance](/azure/data-factory/copy-activity-performance#performance-tuning-steps). When you use Fabric Data Factory to extract data, adjust parallelism, batch size, and connector settings to optimize pipeline performance. For more information, see [Pipeline overview](/fabric/data-factory/pipeline-overview) and [Connector overview](/fabric/data-factory/connector-overview).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Rodrigo Rodríguez](https://www.linkedin.com/in/rod2k10/) | Senior Cloud Solution Architect, AI & Quantum

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Migration guide](/data-migration/)

## Related resources

- [Get started with database architecture design](../../databases/database-get-started.md)
- [Greenfield lakehouse on Fabric](../../example-scenario/data/greenfield-lakehouse-fabric.yml)