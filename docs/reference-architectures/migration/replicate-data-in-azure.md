---
title: Modernize mainframe & midrange data
titleSuffix: Azure Reference Architectures
author: doodlemania2
ms.date: 12/12/2020
description: Learn how to modernize IBM mainframe and midrange data. See how to use a data-first approach to migrate this data to Azure.
ms.custom: fcp
ms.service: architecture-center
ms.category:
  - migration
ms.subservice: reference-architecture
---

# Replicate mainframe and midrange data in Azure

Present-day data storage solutions like the Azure data platform offer improved scalability and performance over mainframe and midrange systems. By modernizing, you can take advantage of these benefits. However, updating technology, infrastructure, and practices is complex. The process involves an exhaustive investigation of business and engineering activities. Data management is one aspect to consider when modernizing. But you also need to look at data visualization and integration.

Successful modernizations use a [data-first strategy][Five reasons a data-first strategy works]. With this approach, organizations focus on the data, rather than the new system. Data management is no longer merely an item on the modernization checklist. Instead, the data becomes the centerpiece. Sustainable systems result, as harmonized, quality-oriented data solutions replace fragmented, poorly governed ones.

This reference architecture outlines an end-to-end modernization plan for mainframe and midrange data sources. The solution uses Azure data platform components in a data-first approach. Specifically, the plan involves:

- **Object conversion**: Converting object definitions from the source data store to corresponding objects in the target data store.
- **Data ingestion**: Connecting to the source data store and extracting data.
- **Data transformation**: Transforming extracted data into appropriate target data store structures.
- **Data storage**: Loading data from the source data store to the target data store, both initially and continually.

## Potential use cases

Mainframe and midrange customers can benefit from this solution, especially when targeting these goals:

- Modernize mission-critical workloads.
- Acquire business intelligence to improve operations and gain a competitive advantage.
- Escape the high costs and rigidity associated with mainframe and midrange data stores.


## Architecture

:::image type="complex" source="./images/replicate-mainframe-data-in-azure.png" alt-text="Architecture diagram showing how to modernize mainframe and midrange systems by migrating data to Azure." border="false":::
   The diagram contains two parts, one for on-premises components, and one for Azure components. The on-premises part contains boxes that represent the file system, the relational and non-relational databases, and the object conversion components. Arrows point from the on-premises components to the Azure components. One of those arrows goes through the object conversion box, and one is labeled on-premises data gateway. The Azure part contains boxes that represent data ingestion and transformation, data storage, Azure services, and client apps. Some arrows point from the on-premises components to the tools and services in the data integration and transformation box. Another arrow points from that box to the data storage box, which contains databases and data stores. Additional arrows point from data storage to Azure services and to client apps.
:::image-end:::

Mainframe and midrange systems update on-premises application databases on a regular interval. To maintain consistency, the solution syncs the latest data with Azure databases. The sync process involves the following steps:

1. Throughout the process:

   1. Azure Data Factory pipelines orchestrate activities, from data extraction to data loading. You can schedule pipeline activities, start them manually, or automatically trigger them.
   1. An on-premises data gateway transfers data quickly and securely between on-premises systems and Azure services.

1. On-premises databases store data:

   - Db2 zOS
   - Db2 for i
   - Db2 LUW
   - IMS
   - ADABAS
   - IDMS

1. Pipelines group activities that perform tasks. To extract data, Azure Data Factory dynamically creates one pipeline per on-premises table. You can then use a massively parallel implementation when you replicate data in Azure. But you can also configure the solution to meet your requirements:

   - Full replication: You replicate the entire database, making necessary modifications to data types and fields in the target Azure database. 
   - Partial, delta, or incremental replication: You use *watermark columns* in the source table to sync updated rows with Azure databases. These columns contain either a continuously incrementing key or a time stamp indicating the table's last update.

   Data Factory also uses pipelines for the following transformation tasks:

   - Data type conversion
   - Data manipulation
   - Data formatting
   - Column derivation
   - Data flattening
   - Data sorting
   - Data filtering

1. A self-hosted integration runtime (IR) provides the environment that Data Factory uses to run and dispatch activities.

1. Azure Data Lake and Azure Blob provide a place for data staging. This step is sometimes required for transforming and merging data from multiple sources.

1. Data preparation takes place next. Factory uses Azure Databricks, custom activities, and pipeline data flows to transform data quickly and effectively. 

1. Azure Data factory loads data into relational and non-relational Azure databases:

   - Azure SQL
   - Azure Database for PostgreSQL
   - Azure Cosmos DB
   - Azure Data Lake Storage
   - Azure Database for Maria DB

   In certain use cases, other tools can also load data.

1. Other tools can also replicate and transform data:

   - SQL Server Integration services (SSIS)
   - Microsoft Service for DRDA: DRDA services which are bundled with Host Integration Server (HIS) can connect to the SQL Family of databases and fetch data into on-premises systems and update the on-premises database with latest information.  A virtual machine on-premises or Azure would be needed to run DRDA/HIS services which can help in connecting to Azure the SQL Family. 
   - Third-party tools: When the solution requires near real-time replication, you can use third-party tools. Some of these agents are available in [Azure Marketplace][Azure Marketplace].

1. Add step for analytics.


## Components

The solution uses the following components.

### Tools

- [Microsoft Service for DRDA][Microsoft Service for DRDA] is a component of [Host Integration Server (HIS)][What is HIS]. Microsoft Service for DRDA is an Application Server (AS) that DRDA Application Requester (AR) clients use. Examples of DRDA AR clients include IBM DB2 for z/OS and DB2 for i5/OS. These clients use the AS to convert Db2 SQL statements and run them on SQL Server.

- [SSMA for Db2][SQL Server Migration Assistant for Db2] automates migration from Db2 to Microsoft database services. While running on a virtual machine (VM), this tool converts Db2 database objects into SQL Server database objects and creates those objects in SQL Server. SSMA for Db2 then migrates data from Db2 to the following services:

  - SQL Server 2012
  - SQL Server 2014
  - SQL Server 2016
  - SQL Server 2017 on Windows and Linux
  - SQL Server 2019 on Windows and Linux
  - Azure SQL Database
  - Azure SQL Managed Instance (maybe leave out this one)

### Data integrators

- [Data Factory][Azure Data Factory] is a hybrid data integration service. You can use this fully managed, serverless solution to create, schedule, and orchestrate ETL and [ELT][ELT] workflows.

- [AzCopy][Get started with AzCopy] is a command-line utility that moves blobs or files into and out of storage accounts.

- [SQL Server Integration Services (SSIS)][SQL Server Integration Services] is a platform for building enterprise-level data integration and transformation solutions. You can use SSIS to solve complex business problems by:
  - Copying or downloading files
  - Loading data warehouses
  - Cleansing and mining data
  - Managing SQL Server objects and data

### Databases

- [Azure SQL Database][Azure SQL Database] is part of the [Azure SQL family][Azure SQL] and is built for the cloud. This service offers all the benefits of a fully managed and evergreen platform as a service. Azure SQL Database also provides AI-powered, automated features that optimize performance and durability. Serverless compute and [Hyperscale storage options][Hyperscale service tier] automatically scale resources on demand.

- [Azure SQL Managed Instance][What is Azure SQL Managed Instance?] is an intelligent, scalable cloud database service that offers all the benefits of a fully managed and evergreen platform as a service. SQL Managed Instance has near 100 percent compatibility with the latest SQL Server (Enterprise Edition) database engine. This service also provides a native virtual network implementation that addresses common security concerns.

- [Azure SQL on VM][Azure SQL on VM] Lift and shift your SQL Server workloads to the cloud to get the combined performance, security, and analytics of SQL Server with flexibility and hybrid connectivity of Azure with 100 percent code compatibility. Access the latest SQL Server updates and releases, including SQL Server 2019. SQL Server on Azure Virtual Machines is part of the Azure SQL family, which allows you to migrate existing apps or build new apps on the best cloud destination for your mission-critical SQL Server workloads.

- [Azure Database for PostgreSQL][Azure Database for PostgreSQL] is a fully managed relational database service that's based on the community edition of the open-source [PostgreSQL][PostgreSQL] database engine. With this service, you can focus on application innovation instead of database management. You can also scale your workload quickly and easily.

- [Azure Database for MySQL][What is Azure Database for MySQL?] is a fully managed relational database service based on the [community edition of the open-source MySQL database engine][MySQL Community Edition].

- [Azure Cosmos DB][Welcome to Azure Cosmos DB] is a globally distributed, [multi-model][The rise of the multimodel database] database. With Azure Cosmos DB, your solutions can elastically and independently scale throughput and storage across any number of geographic regions. This fully managed [NoSQL][What is NoSQL? Databases for a cloud-scale future] database service guarantees single-digit millisecond latencies at the ninety-ninth percentile anywhere in the world.

- [Azure Data Lake Storage][Azure Data Lake Storage] is a storage repository that holds a large amount of data in its native, raw format. Data lake stores are optimized for scaling to terabytes and petabytes of data. The data typically comes from multiple, heterogeneous sources and may be structured, semi-structured, or unstructured.

### Networking

- An [on-premises data gateway][What is an on-premises data gateway?] acts as a bridge that connects on-premises data with cloud services. Typically, you [install the gateway on a dedicated on-premises VM][Install an on-premises data gateway]. Cloud services can then securely use on-premises data.

- [Azure VMs][Azure virtual machines] are on-demand, scalable computing resources that are available with Azure. An Azure VM provides the flexibility of virtualization. But it eliminates the maintenance demands of physical hardware. Azure VMs offer a choice of operating systems, including Windows and Linux.

## Recommendations

- When you use the Data Provider for Host Files client to convert data, [turn on connection pooling][Configure HIS component for performance] to reduce connection startup time.
- When you use Data Factory to extract data, take steps to [tune the performance of the copy activity][Performance tuning steps].

## Considerations

Keep these points in mind when considering this architecture.

### Manageability considerations

When you use an on-premises application gateway, be aware of [limits on read and write operations][Gateway considerations].

### Security considerations

- The on-premises data gateway provides data protection during transfers from on-premises to Azure systems.
- When you use Data Provider for Host Files to convert data, follow the recommendations in [Data Providers for Host Files Security and Protection][Data Providers for Host Files Security and Protection] to improve security.

## Pricing
Use the [Azure pricing calculator][Azure pricing calculator] to estimate the cost of implementing this solution.

## Next steps

- Contact [Azure Data Engineering - Mainframe & Midrange Modernization][Email address for information on Azure Data Engineering Mainframe and Midrange Modernization] for more information.
- Read the [Migration guide][Migration guide].

## Related resources

- [Azure data architecture guide][Azure data architecture guide]
- [Azure data platform end-to-end][Azure data platform end-to-end]

[ADABAS]: https://www.softwareag.com/en_corporate/platform/adabas-natural.html
[Get started with AzCopy]: https://docs.microsoft.com/azure/storage/common/storage-use-azcopy-v10
[Azure data architecture guide]: https://docs.microsoft.com/azure/architecture/data-guide/
[Azure Data Factory]: https://azure.microsoft.com/services/data-factory/
[Azure Data Lake Storage]: https://azure.microsoft.com/services/storage/data-lake-storage/
[Azure data platform end-to-end]: https://docs.microsoft.com/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end
[Azure Database for MariaDB documentation]: https://docs.microsoft.com/azure/mariadb/
[Azure Database for PostgreSQL]: https://azure.microsoft.com/services/postgresql/
[Azure pricing calculator]: https://azure.microsoft.com/pricing/calculator
[Azure Services overview]: https://azurecharts.com/overview
[Azure SQL]: https://azure.microsoft.com/services/azure-sql/
[Azure SQL Database]: https://azure.microsoft.com/services/sql-database/
[Azure Storage]: https://docs.microsoft.com/azure/storage/
[Azure virtual machines]: https://azure.microsoft.com/services/virtual-machines/
[Comparison of hierarchical and relational databases]: https://www.ibm.com/support/knowledgecenter/SSEPH2_14.1.0/com.ibm.ims14.doc.apg/ims_comparehierandreldbs.htm
[Configure HIS component for performance]: https://docs.microsoft.com/host-integration-server/core/data-for-host-files#configuringForPerformance
[Data Provider]: https://docs.microsoft.com/host-integration-server/core/data-for-host-files
[Data Providers for Host Files Security and Protection]: https://docs.microsoft.com/host-integration-server/core/data-providers-for-host-files-security-and-protection
[Datacom]: https://www.broadcom.com/products/mainframe/databases-database-mgmt/datacom
[Email address for information on Azure Data Engineering Mainframe and Midrange Modernization]: mailto:datasqlninja@microsoft.com
[ELT]: https://www.ibm.com/cloud/learn/etl#toc-etl-vs-elt-goFgkQcP
[ETL]: https://www.ibm.com/cloud/learn/etl
[Five reasons a data-first strategy works]: https://resources.syniti.com/featured-articles/5-reasons-a-data-first-strategy-works
[Flat files]: https://www.pcmag.com/encyclopedia/term/flat-file
[Gateway considerations]: https://docs.microsoft.com/data-integration/gateway/service-gateway-onprem#considerations
[GDG]: https://www.ibm.com/support/knowledgecenter/zosbasics/com.ibm.zos.zconcepts/zconcepts_175.htm
[Hyperscale service tier]: https://docs.microsoft.com/azure/azure-sql/database/service-tier-hyperscale
[IBM Db2 10.5 for Linux, Unix and Windows documentation]: https://www.ibm.com/support/knowledgecenter/en/SSEPGG_10.5.0/com.ibm.db2.luw.kc.doc/welcome.html
[IBM Db2 for i]: https://www.ibm.com/support/pages/ibm-db2-i
[IBM Db2 for z/OS]: https://www.ibm.com/analytics/db2/zos
[IDMS]: https://www.broadcom.com/products/mainframe/databases-database-mgmt/idms
[IMS]: https://www.ibm.com/it-infrastructure/z/ims
[Install an on-premises data gateway]: https://docs.microsoft.com/data-integration/gateway/service-gateway-install
[MariaDB]: https://mariadb.org/
[Migration guide]: https://datamigration.microsoft.com/
[MySQL Community Edition]: https://www.mysql.com/products/community/
[Network model]: https://web.archive.org/web/20060904190944/http://coronet.iicm.edu/wbtmaster/allcoursescontent/netlib/ndm1.htm
[Performance tuning steps]: https://docs.microsoft.com/azure/data-factory/copy-activity-performance#performance-tuning-steps
[PostgreSQL]: https://www.postgresql.org/
[The rise of the multimodel database]: https://www.infoworld.com/article/2861579/the-rise-of-the-multimodel-database.html
[SQL Server Integration Services]: https://docs.microsoft.com/sql/integration-services/sql-server-integration-services
[SQL Server Migration Assistant for Db2]: https://docs.microsoft.com/sql/ssma/db2/sql-server-migration-assistant-for-db2-db2tosql
[VSAM]: https://www.ibm.com/support/knowledgecenter/zosbasics/com.ibm.zos.zconcepts/zconcepts_169.htm
[Welcome to Azure Cosmos DB]: https://docs.microsoft.com/azure/cosmos-db/introduction
[What is an on-premises data gateway?]: https://docs.microsoft.com/data-integration/gateway/service-gateway-onprem
[What is Azure Database for MySQL?]: https://docs.microsoft.com/azure/mysql/overview
[What is Azure SQL Managed Instance?]: https://docs.microsoft.com/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview
[What is HIS]: https://docs.microsoft.com/host-integration-server/what-is-his
[What is NoSQL? Databases for a cloud-scale future]: https://www.infoworld.com/article/3240644/what-is-nosql-databases-for-a-cloud-scale-future.html


[Azure Marketplace]: https://azuremarketplace.microsoft.com/marketplace/
[Azure SQL on VM]: https://azure.microsoft.com/services/virtual-machines/sql-server/
[Microsoft Service for DRDA]: https://docs.microsoft.com/host-integration-server/what-is-his#Data