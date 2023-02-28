This reference architecture outlines an implementation plan for replicating and syncing data during modernization to Azure. It discusses technical aspects like data stores, tools, and services.

## Architecture

:::image type="complex" source="./images/sync-mainframe-data-with-azure.png" alt-text="Architecture diagram showing how to sync on-premises and Azure databases during mainframe modernization." border="false" lightbox="./images/sync-mainframe-data-with-azure.png":::
   The diagram contains two parts, one for on-premises components, and one for Azure components. The on-premises part contains rectangles, one that pictures databases and one that contains integration tools. A server icon that represents the self-hosted integration runtime is also located in the on-premises part. The Azure part also contains rectangles. One is for pipelines. Others are for services that the solution uses for staging and preparing data. Another contains Azure databases. Arrows point from on-premises components to Azure components. These arrows represent the flow of data in the replication and sync processes. One of the arrows goes through the on-premises data gateway.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/sync-mainframe-data-with-azure.vsdx) of this architecture.*

### Workflow

Mainframe and midrange systems update on-premises application databases on a regular interval. To maintain consistency, the solution syncs the latest data with Azure databases. The sync process involves the following steps:

1. These actions occur throughout the process:

   1. An on-premises data gateway transfers data quickly and securely between on-premises systems and Azure services. With this configuration, the on-premises data gateway can receive instructions from Azure and replicate data without the on-premises network directly exposing the local data assets.
   1. Azure Data Factory pipelines orchestrate activities that range from data extraction to data loading. You can schedule pipeline activities, start them manually, or automatically trigger them.

1. On-premises databases like Db2 zOS, Db2 for i, and Db2 LUW store the data.

1. Pipelines group the activities that perform tasks. To extract data, Data Factory dynamically creates one pipeline per on-premises table. You can then use a massively parallel implementation when you replicate data in Azure. But you can also configure the solution to meet your requirements:

   - Full replication: You replicate the entire database, making necessary modifications to data types and fields in the target Azure database.
   - Partial, delta, or incremental replication: You use *watermark columns* in source tables to sync updated rows with Azure databases. These columns contain either a continuously incrementing key or a time stamp indicating the table's last update.

   Data Factory also uses pipelines for the following transformation tasks:

   - Data type conversion
   - Data manipulation
   - Data formatting
   - Column derivation
   - Data flattening
   - Data sorting
   - Data filtering

1. A self-hosted integration runtime (IR) provides the environment that Data Factory uses to run and dispatch activities.

1. Azure Data Lake Storage Gen2 and Azure Blob Storage provide a place for data staging. This step is sometimes required for transforming and merging data from multiple sources.

1. Data preparation takes place next. Data Factory uses Azure Databricks, custom activities, and pipeline data flows to transform data quickly and effectively.

1. Data Factory loads data into relational and non-relational Azure databases:

   - Azure SQL
   - Azure Database for PostgreSQL
   - Azure Cosmos DB
   - Azure Data Lake Storage
   - Azure Database for MariaDB
   - Azure Database for MySQL

   In certain use cases, other tools can also load data.

1. Other tools can also replicate and transform data:

   - Microsoft Service for Distributed Relational Database Architecture (DRDA): These DRDA services can connect to the Azure SQL family of databases and keep on-premises databases up to date. These services run on an on-premises virtual machine (VM) or an Azure VM.
   - SQL Server Migration Assistance (SSMA) for Db2: This tool migrates schemas and data from IBM Db2 databases to Azure databases.
   - SQL Server Integration Services (SSIS): This platform can extract, transform, and load data.
   - Third-party tools: When the solution requires near real-time replication, you can use third-party tools. Some of these agents are available in [Azure Marketplace][Azure Marketplace].

1. Azure Synapse Analytics manages the data and makes it available for business intelligence and machine learning applications.

### Components

The solution uses the following components:

#### Tools

- [Microsoft Service for DRDA][Microsoft Service for DRDA] is a component of [Host Integration Server (HIS)][What is HIS]. Microsoft Service for DRDA is an Application Server (AS) that DRDA Application Requester (AR) clients use. Examples of DRDA AR clients include IBM Db2 for z/OS and Db2 for i5/OS. These clients use the AS to convert Db2 SQL statements and run them on SQL Server.

- [SSMA for Db2][SQL Server Migration Assistant for Db2] automates migration from Db2 to Microsoft database services. While running on a VM, this tool converts Db2 database objects into SQL Server database objects and creates those objects in SQL Server. SSMA for Db2 then migrates data from Db2 to the following services:

  - SQL Server 2012
  - SQL Server 2014
  - SQL Server 2016
  - SQL Server 2017 on Windows and Linux
  - SQL Server 2019 on Windows and Linux
  - Azure SQL Database

- [Azure Synapse Analytics][Azure Synapse Analytics] is an analytics service for data warehouses and big data systems. This tool uses Spark technologies and has deep integration with Power BI, Azure Machine Learning, and other Azure services.

#### Data integrators

- [Azure Data Factory][Azure Data Factory] is a hybrid data integration service. You can use this fully managed, serverless solution to create, schedule, and orchestrate ETL and [ELT][ELT] workflows.

- [Azure Synapse Analytics] is an enterprise analytics service that accelerates time to insight, across data warehouses and big data systems. Azure Synapse brings together the best of SQL technologies (that are used in enterprise data warehousing), Spark technologies used for big data, Data Explorer for log and time series analytics, Pipelines for data integration and ETL/ELT, and deep integration with other Azure services, such as Power BI, Azure Cosmos DB, and Azure Machine Learning.

- [SQL Server Integration Services (SSIS)][SQL Server Integration Services] is a platform for building enterprise-level data integration and transformation solutions. You can use SSIS to manage, replicate, cleanse, and mine data.

- [Azure Databricks][Azure Databricks] is a data analytics platform. Based on the Apache Spark open-source distributed processing system, Azure Databricks is optimized for Azure cloud services. In an analytics workflow, Azure Databricks reads data from multiple sources and uses Spark to provide insights.

#### Data storage

- [Azure SQL Database][Azure SQL Database] is part of the [Azure SQL][Azure SQL] family and is built for the cloud. This service offers all the benefits of a fully managed and evergreen platform as a service. SQL Database also provides AI-powered, automated features that optimize performance and durability. Serverless compute and [Hyperscale storage options][Hyperscale service tier] automatically scale resources on demand.

- [SQL Managed Instance][Azure SQL Managed Instance] is part of the Azure SQL service portfolio. This intelligent, scalable, cloud database service combines the broadest SQL Server engine compatibility with all the benefits of a fully managed and evergreen platform as a service. With SQL Managed Instance, you can modernize existing apps at scale.

- [SQL Server on Azure VMs][Azure SQL on VM] provides a way to lift and shift SQL Server workloads to the cloud with 100 percent code compatibility. As part of the Azure SQL family, SQL Server on Azure VMs offers the combined performance, security, and analytics of SQL Server with the flexibility and hybrid connectivity of Azure. With SQL Server on Azure VMs, you can migrate existing apps or build new apps. You can also access the latest SQL Server updates and releases, including SQL Server 2019.

- [Azure Database for PostgreSQL][Azure Database for PostgreSQL] is a fully managed relational database service that's based on the community edition of the open-source [PostgreSQL][PostgreSQL] database engine. With this service, you can focus on application innovation instead of database management. You can also scale your workload quickly and easily.

- [Azure Cosmos DB][Azure Cosmos DB] is a globally distributed, [multimodel][The rise of the multimodel database] database. With Azure Cosmos DB, your solutions can elastically and independently scale throughput and storage across any number of geographic regions. This fully managed [NoSQL][What is NoSQL? Databases for a cloud-scale future] database service guarantees single-digit millisecond latencies at the ninety-ninth percentile anywhere in the world.

- [Data Lake Storage][Azure Data Lake Storage] is a storage repository that holds a large amount of data in its native, raw format. Data lake stores are optimized for scaling to terabytes and petabytes of data. The data typically comes from multiple, heterogeneous sources and may be structured, semi-structured, or unstructured. [Data Lake Storage Gen2][Azure Data Lake Storage Gen2] combines Data Lake Storage Gen1 capabilities with Blob Storage. This next-generation data lake solution provides file system semantics, file-level security, and scale. But it also offers the tiered storage, high availability, and disaster recovery capabilities of Blob Storage.

- [Azure Database for MariaDB][Azure Database for MariaDB] is a cloud-based relational database service. This service is based on the [MariaDB][MariaDB] community edition database engine.

- [Azure Database for MySQL][Azure Database for MySQL] is a fully managed relational database service based on the [community edition of the open-source MySQL database engine][MySQL Community Edition].

- [Blob Storage][Azure Blob Storage] provides optimized cloud object storage that manages massive amounts of unstructured data.

#### Networking

- An [on-premises data gateway][What is an on-premises data gateway?] acts as a bridge that connects on-premises data with cloud services. Typically, you [install the gateway on a dedicated on-premises VM][Install an on-premises data gateway]. Cloud services can then securely use on-premises data.

- An [IR][Integration runtime in Azure Data Factory] is the compute infrastructure that Data Factory uses to integrate data across different network environments. Data Factory uses [self-hosted IRs][Self-hosted integration runtime] to copy data between cloud data stores and data stores in on-premises networks. You can also use [Azure Synapse Pipelines](/azure/synapse-analytics/get-started-pipelines).

## Scenario details

Data availability and integrity play an important role in mainframe and midrange modernization. [Data-first strategies][Modernize mainframe & midrange data] help to keep data intact and available during migration to Azure. To avoid impacting applications during modernization, sometimes you need to replicate data quickly or keep on-premises data in sync with Azure databases.

Specifically, this solution covers:

- Extraction: Connecting to and extracting from a source database.
- Transformation:
  - Staging: Temporarily storing data in its original format and preparing it for transformation.
  - Preparation: Transforming and manipulating data by using mapping rules that meet target database requirements.
- Loading: Inserting data into a target database.

### Potential use cases

Data replication and sync scenarios that can benefit from this solution include:

- Command Query Responsibility Segregation (CQRS) architectures that use Azure to service all inquire channels.
- Environments that test on-premises applications and rehosted or re-engineered applications in parallel.
- On-premises systems with tightly coupled applications that require phased remediation or modernization.

## Recommendations

When you use Data Factory to extract data, take steps to [tune the performance of the copy activity][Performance tuning steps].

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

Keep these points in mind when considering this architecture.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- Infrastructure management, including [availability][Types of Databases on Azure], is automated in Azure databases.

- See [Pooling and failover][Pooling and failover] for information on the failover protection that Microsoft Service for DRDA provides.

- You can cluster the on-premises data gateway and IR to provide higher availability guarantees.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- Make use of [network security groups](/azure/virtual-network/manage-network-security-group) to limit access of services to only what they need to function.

- Use [private endpoints](/azure/private-link/private-endpoint-overview) for your PaaS (Platform as a Service) services. Use service firewalls to supplement security for your services that are both reachable and unreachable through the Internet.

- Be aware of the differences between on-premises client identities and client identities in Azure. You will need to compensate for any differences.

- Use managed identities for component-to-component data flows.

- See [Planning and Architecting Solutions Using Microsoft Service for DRDA](/host-integration-server/core/planning-and-architecting-solutions-using-microsoft-service-for-drda) to learn about the types of client connections that Microsoft Service for DRDA supports. Client connections affect the nature of transactions, pooling, failover, authentication, and encryption on your network.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- Pricing models vary between component services. Review the pricing models of the available component services to ensure the pricing models fit your budget.

- Use the [Azure pricing calculator][Azure pricing calculator] to estimate the cost of implementing this solution.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

- Infrastructure management, including [scalability][Types of Databases on Azure], is automated in Azure databases.

- You can [scale out the self-hosted IR][Self-hosted IR compute resource and scaling] by associating the logical instance with multiple on-premises machines in active-active mode.

- You can cluster the on-premises data gateway and IR for scalability.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

- When you use an on-premises application gateway, be aware of [limits on read and write operations][Gateway considerations].

- Consider [Azure ExpressRoute][Azure ExpressRoute] as a high-scale option if your implementation uses significant bandwidth for initial replication or ongoing changed data replication.

- The [self-hosted IR can only run on a Windows operating system][Self-hosted IR compute resource and scaling].

## Next steps

- Contact [Azure Data Engineering - On-premises Modernization][Email address for information on Azure Data Engineering On-premises Modernization] for more information.
- Read the [Migration guide][Migration guide].

## Related resources

- [Azure data architecture guide][Azure data architecture guide]
- [Azure data platform end-to-end][Azure data platform end-to-end]

[Azure Blob Storage]: https://azure.microsoft.com/services/storage/blobs/
[Azure Cosmos DB]: https://azure.microsoft.com/services/cosmos-db/
[Azure data architecture guide]: ../../data-guide/index.md
[Azure Data Factory]: https://azure.microsoft.com/services/data-factory/
[Azure Data Lake Storage]: https://azure.microsoft.com/services/storage/data-lake-storage/
[Azure Data Lake Storage Gen2]: /azure/databricks/data/data-sources/azure/azure-datalake-gen2
[Azure data platform end-to-end]: ../../example-scenario/dataplate2e/data-platform-end-to-end.yml
[Azure Database for MariaDB]: https://azure.microsoft.com/services/mariadb/
[Azure Database for PostgreSQL]: https://azure.microsoft.com/services/postgresql/
[Azure Databricks]: https://azure.microsoft.com/services/databricks/
[Azure ExpressRoute]: https://azure.microsoft.com/services/expressroute/
[Azure Marketplace]: https://azuremarketplace.microsoft.com/marketplace/
[Azure pricing calculator]: https://azure.microsoft.com/pricing/calculator
[Azure SQL]: https://azure.microsoft.com/services/azure-sql/
[Azure SQL Database]: https://azure.microsoft.com/services/sql-database/
[Azure SQL Managed Instance]: https://azure.microsoft.com/services/azure-sql/sql-managed-instance/
[Azure SQL on VM]: https://azure.microsoft.com/services/virtual-machines/sql-server/
[Azure Synapse Analytics]: https://azure.microsoft.com/services/synapse-analytics/
[Azure virtual machines]: https://azure.microsoft.com/services/virtual-machines/
[ELT]: https://www.ibm.com/cloud/learn/etl#toc-etl-vs-elt-goFgkQcP
[Email address for information on Azure Data Engineering On-premises Modernization]: mailto:datasqlninja@microsoft.com
[Gateway considerations]: /data-integration/gateway/service-gateway-onprem#considerations
[Hyperscale service tier]: /azure/azure-sql/database/service-tier-hyperscale
[Install an on-premises data gateway]: /data-integration/gateway/service-gateway-install
[Installing SSMA for DB2 client (DB2ToSQL) Prerequisites]: /sql/ssma/db2/installing-ssma-for-db2-client-db2tosql?view=sql-server-ver15#prerequisites
[Integration runtime in Azure Data Factory]: /azure/data-factory/concepts-integration-runtime
[MariaDB]: https://mariadb.org/
[Microsoft Service for DRDA]: /host-integration-server/what-is-his#Data
[Migration guide]: https://datamigration.microsoft.com/
[Modernize mainframe & midrange data]: /azure/architecture/example-scenario/mainframe/modernize-mainframe-data-to-azure
[MySQL Community Edition]: https://www.mysql.com/products/community/
[Network transports and transactions]: /host-integration-server/core/planning-and-architecting-solutions-using-microsoft-service-for-drda#network-transports-and-transactions
[Performance tuning steps]: /azure/data-factory/copy-activity-performance#performance-tuning-steps
[Pooling and failover]: /host-integration-server/core/planning-and-architecting-solutions-using-microsoft-service-for-drda#pooling-and-failover
[PostgreSQL]: https://www.postgresql.org/
[The rise of the multimodel database]: https://www.infoworld.com/article/2861579/the-rise-of-the-multimodel-database.html
[Self-hosted integration runtime]: /azure/data-factory/concepts-integration-runtime#self-hosted-integration-runtime
[Self-hosted IR compute resource and scaling]: /azure/data-factory/concepts-integration-runtime#self-hosted-ir-compute-resource-and-scaling
[SQL Server Integration Services]: /sql/integration-services/sql-server-integration-services
[SQL Server Migration Assistant for Db2]: /sql/ssma/db2/sql-server-migration-assistant-for-db2-db2tosql
[Types of Databases on Azure]: https://azure.microsoft.com/product-categories/databases/
[What is an on-premises data gateway?]: /data-integration/gateway/service-gateway-onprem
[Azure Database for MySQL]: https://azure.microsoft.com/services/mysql/
[What is HIS]: /host-integration-server/what-is-his
[What is NoSQL? Databases for a cloud-scale future]: https://www.infoworld.com/article/3240644/what-is-nosql-databases-for-a-cloud-scale-future.html
[Azure Synapse Analytics]: /azure/synapse-analytics/overview-what-is