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

:::image type="complex" source="./images/modernize-mainframe-data-with-azure.png" alt-text="Architecture diagram showing how to modernize mainframe and midrange systems by migrating data to Azure." border="false":::
   The diagram contains two parts, one for on-premises components, and one for Azure components. The on-premises part contains boxes that represent the file system, the relational and non-relational databases, and the object conversion components. Arrows point from the on-premises components to the Azure components. One of those arrows goes through the object conversion box, and one is labeled on-premises data gateway. The Azure part contains boxes that represent data ingestion and transformation, data storage, Azure services, and client apps. Some arrows point from the on-premises components to the tools and services in the data integration and transformation box. Another arrow points from that box to the data storage box, which contains databases and data stores. Additional arrows point from data storage to Azure services and to client apps.
:::image-end:::

*Download a [Visio file][Visio version of architecture diagram] of this architecture.*

Data modernization involves the following steps. Throughout the process, an on-premises data gateway transfers data quickly and securely between on-premises systems and Azure services (1).

### Object conversion

The object conversion process extracts object definitions from sources. The definitions are then converted into corresponding objects on the target data store (2).

- Microsoft SQL Server Migration Assistance (SSMA) for Db2 migrates schemas and data from IBM Db2 databases to Azure databases.

- Data Provider for Host Files converts objects by:

  - Parsing COBOL and RPG record layouts, or *copybooks*.
  - Mapping the copybooks to C# objects that .NET applications use.
- Third-party tools perform automated object conversion on non-relational databases, file systems, and other data stores.

### Data ingestion and transformation

In the next step, the process migrates data.

#### File data

- Data Provider connects remotely to IBM host file system servers (3a). With non-mainframe systems, Data Provider reads data offline.

  Mainframe and midrange systems store data on DASD or tape in EBCDIC format in these types of files:

  - Indexed [VSAM][VSAM] files
  - Non-indexed [GDG][GDG] files
  - [Flat files][Flat files].

  COBOL, PL/I, and assembly language copybooks define the data structure of these files. Data Provider converts the data from EBCDIC to ASCII format based on the copybook layout.

- FTP converts and transfers mainframe and midrange datasets with single layouts and unpacked fields to Azure (3b).

#### Database data

- IBM mainframe and midrange systems store data in relational databases including:

  - [Db2 for z/OS][IBM Db2 for z/OS]
  - [Db2 LUW][IBM Db2 10.5 for Linux, Unix and Windows documentation]
  - [Db2 for i][IBM Db2 for i]

  These services migrate the database data (3c):

  - Azure Data Factory uses a Db2 connector to extract and integrate data from these databases.
  - SQL Server Integration Services (SSIS) handles a broad range of data [ETL][ETL] tasks.

- IBM mainframe and midrange systems store data in non-relational databases including:

  - [IDMS][IDMS], a [network model][Network model] Database Management System (DBMS)
  - [IMS][IMS], a [hierarchical model][Comparison of hierarchical and relational databases] DBMS
  - [ADABAS][ADABAS]
  - [Datacom][Datacom]

  Third-party products integrate data from these databases (3d).

Azure services like Data Factory and AzCopy load data into Azure databases and data storage (4). Third-party solutions and custom loading solutions can also load data.

### Data storage

Azure offers many managed data storage solutions (5):

- Databases:

  - Azure SQL Database
  - Azure Database for PostgreSQL
  - Azure Cosmos DB
  - Azure Database for MySQL
  - Azure Database for MariaDB
  - Azure SQL Managed Instance

- Storage:

  - Azure Data Lake Storage
  - Azure Storage

### Data tier

- A range of Azure Services use the modernized data tier for computing, analytics, storage, and networking (6).

- Existing client applications also use the modernized data tier (7).

## Components

The solution uses the following components.

### Tools

- [SSMA for Db2][SQL Server Migration Assistant for Db2] automates migration from Db2 to Microsoft database services. While running on a virtual machine (VM), this tool converts Db2 database objects into SQL Server database objects and creates those objects in SQL Server. SSMA for Db2 then migrates data from Db2 to the following services:

  - SQL Server 2012
  - SQL Server 2014
  - SQL Server 2016
  - SQL Server 2017 on Windows and Linux
  - SQL Server 2019 on Windows and Linux
  - Azure SQL Database
  - Azure SQL Managed Instance

- [Data Provider for Host Files][Data Provider] is a component of [Host Integration Server (HIS)][What is HIS] that uses offline, SNA, or TCP/IP connections.

  - With offline connections, Data Provider reads and writes records in a local binary file.
  - With SNA and TCP/IP connections, Data Provider reads and writes records stored in remote z/OS (IBM z series Mainframe) datasets or remote i5/OS (IBM AS/400 and iSeries systems) physical files. Only i5/OS systems use TCP/IP.

- [Azure Services][Azure Services overview] provide environments, tools, and processes for developing and scaling new applications in the public cloud.

### Data integrators

- [Data Factory][Azure Data Factory] is a hybrid data integration service. You can use this fully managed, serverless solution to create, schedule, and orchestrate ETL and [ELT][ELT] workflows.

- [AzCopy][Get started with AzCopy] is a command-line utility that moves blobs or files into and out of storage accounts.

- [SQL Server Integration Services (SSIS)][SQL Server Integration Services] is a platform for building enterprise-level data integration and transformation solutions. You can use SSIS to solve complex business problems by:
  - Copying or downloading files
  - Loading data warehouses
  - Cleansing and mining data
  - Managing SQL Server objects and data

### Data store

- [Azure SQL Database][Azure SQL Database] is part of the [Azure SQL family][Azure SQL] and is built for the cloud. This service offers all the benefits of a fully managed and evergreen platform as a service. Azure SQL Database also provides AI-powered, automated features that optimize performance and durability. Serverless compute and [Hyperscale storage options][Hyperscale service tier] automatically scale resources on demand.

- [Azure Database for PostgreSQL][Azure Database for PostgreSQL] is a fully managed relational database service that's based on the community edition of the open-source [PostgreSQL][PostgreSQL] database engine. With this service, you can focus on application innovation instead of database management. You can also scale your workload quickly and easily.

- [Azure Cosmos DB][Welcome to Azure Cosmos DB] is a globally distributed, [multi-model][The rise of the multimodel database] database. With Azure Cosmos DB, your solutions can elastically and independently scale throughput and storage across any number of geographic regions. This fully managed [NoSQL][What is NoSQL? Databases for a cloud-scale future] database service guarantees single-digit millisecond latencies at the ninety-ninth percentile anywhere in the world.

- [Azure Database for MySQL][What is Azure Database for MySQL?] is a fully managed relational database service based on the [community edition of the open-source MySQL database engine][MySQL Community Edition].

- [Azure Database for MariaDB][Azure Database for MariaDB documentation] is a cloud-based relational database service. This service is based on the [MariaDB][MariaDB] community edition database engine.

- [Azure SQL Managed Instance][What is Azure SQL Managed Instance?] is an intelligent, scalable cloud database service that offers all the benefits of a fully managed and evergreen platform as a service. SQL Managed Instance has near 100 percent compatibility with the latest SQL Server (Enterprise Edition) database engine. This service also provides a native virtual network implementation that addresses common security concerns.

- [Azure Data Lake Storage][Azure Data Lake Storage] is a storage repository that holds a large amount of data in its native, raw format. Data lake stores are optimized for scaling to terabytes and petabytes of data. The data typically comes from multiple, heterogeneous sources and may be structured, semi-structured, or unstructured.

- [Azure Storage][Azure Storage] is a cloud storage solution that includes object, file, disk, queue, and table storage. Services include hybrid storage solutions and tools for transferring, sharing, and backing up data.

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

- Contact [Azure Data Engineering - Mainframe &amp; Midrange Modernization][Email address for information on Azure Data Engineering Mainframe and Midrange Modernization] for more information.
- Read the [Migration guide][Migration guide].

## Related resources

- [Azure data architecture guide][Azure data architecture guide]
- [Azure data platform end-to-end][Azure data platform end-to-end]

[ADABAS]: https://www.softwareag.com/en_corporate/platform/adabas-natural.html
[Get started with AzCopy]: /azure/storage/common/storage-use-azcopy-v10
[Azure data architecture guide]: ../../data-guide/index.md
[Azure Data Factory]: https://azure.microsoft.com/services/data-factory/
[Azure Data Lake Storage]: https://azure.microsoft.com/services/storage/data-lake-storage/
[Azure data platform end-to-end]: ../../example-scenario/dataplate2e/data-platform-end-to-end.yml
[Azure Database for MariaDB documentation]: /azure/mariadb/
[Azure Database for PostgreSQL]: https://azure.microsoft.com/services/postgresql/
[Azure pricing calculator]: https://azure.microsoft.com/pricing/calculator
[Azure Services overview]: https://azurecharts.com/overview
[Azure SQL]: https://azure.microsoft.com/services/azure-sql/
[Azure SQL Database]: https://azure.microsoft.com/services/sql-database/
[Azure Storage]: /azure/storage/
[Azure virtual machines]: https://azure.microsoft.com/services/virtual-machines/
[Comparison of hierarchical and relational databases]: https://www.ibm.com/support/knowledgecenter/SSEPH2_14.1.0/com.ibm.ims14.doc.apg/ims_comparehierandreldbs.htm
[Configure HIS component for performance]: /host-integration-server/core/data-for-host-files#configuringForPerformance
[Data Provider]: /host-integration-server/core/data-for-host-files
[Data Providers for Host Files Security and Protection]: /host-integration-server/core/data-providers-for-host-files-security-and-protection
[Datacom]: https://www.broadcom.com/products/mainframe/databases-database-mgmt/datacom
[Email address for information on Azure Data Engineering Mainframe and Midrange Modernization]: mailto:datasqlninja@microsoft.com
[ELT]: https://www.ibm.com/cloud/learn/etl#toc-etl-vs-elt-goFgkQcP
[ETL]: https://www.ibm.com/cloud/learn/etl
[Five reasons a data-first strategy works]: http://www.enterpriseappstoday.com/data-management/5-reasons-a-data-first-strategy-works.html
[Flat files]: https://www.pcmag.com/encyclopedia/term/flat-file
[Gateway considerations]: /data-integration/gateway/service-gateway-onprem#considerations
[GDG]: https://www.ibm.com/support/knowledgecenter/zosbasics/com.ibm.zos.zconcepts/zconcepts_175.htm
[Hyperscale service tier]: /azure/azure-sql/database/service-tier-hyperscale
[IBM Db2 10.5 for Linux, Unix and Windows documentation]: https://www.ibm.com/support/knowledgecenter/en/SSEPGG_10.5.0/com.ibm.db2.luw.kc.doc/welcome.html
[IBM Db2 for i]: https://www.ibm.com/support/pages/db2-ibm-i
[IBM Db2 for z/OS]: https://www.ibm.com/analytics/db2/zos
[IDMS]: https://www.broadcom.com/products/mainframe/databases-database-mgmt/idms
[IMS]: https://www.ibm.com/it-infrastructure/z/ims
[Install an on-premises data gateway]: /data-integration/gateway/service-gateway-install
[MariaDB]: https://mariadb.org/
[Migration guide]: https://datamigration.microsoft.com/
[MySQL Community Edition]: https://www.mysql.com/products/community/
[Network model]: https://web.archive.org/web/20060904190944/http://coronet.iicm.edu/wbtmaster/allcoursescontent/netlib/ndm1.htm
[Performance tuning steps]: /azure/data-factory/copy-activity-performance#performance-tuning-steps
[PostgreSQL]: https://www.postgresql.org/
[The rise of the multimodel database]: https://www.infoworld.com/article/2861579/the-rise-of-the-multimodel-database.html
[SQL Server Integration Services]: /sql/integration-services/sql-server-integration-services
[SQL Server Migration Assistant for Db2]: /sql/ssma/db2/sql-server-migration-assistant-for-db2-db2tosql
[Visio version of architecture diagram]: https://arch-center.azureedge.net/US-1785470-PR-1990-modernize-mainframe-data-with-azure.vsdx
[VSAM]: https://www.ibm.com/support/knowledgecenter/zosbasics/com.ibm.zos.zconcepts/zconcepts_169.htm
[Welcome to Azure Cosmos DB]: /azure/cosmos-db/introduction
[What is an on-premises data gateway?]: /data-integration/gateway/service-gateway-onprem
[What is Azure Database for MySQL?]: /azure/mysql/overview
[What is Azure SQL Managed Instance?]: /azure/azure-sql/managed-instance/sql-managed-instance-paas-overview
[What is HIS]: /host-integration-server/what-is-his
[What is NoSQL? Databases for a cloud-scale future]: https://www.infoworld.com/article/3240644/what-is-nosql-databases-for-a-cloud-scale-future.html
