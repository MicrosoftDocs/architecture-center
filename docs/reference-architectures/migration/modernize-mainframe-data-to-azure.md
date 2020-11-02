---
title: Migrate mainframe + midrange data to Azure
author: JKirsch1
ms.date: 11/02/2020
description: Learn how to modernize IBM mainframe and midrange data. See how to use a data-first approach to migrate this data to Azure.
ms.custom: fcp
ms.service: architecture-center
ms.category:
  - migration
ms.subservice: reference-architecture
---

# Migrate mainframe and midrange data to Azure

Present-day data store solutions like the Azure data platform offer improved scalability and performance over mainframe and midrange systems. However, updating technology, infrastructure, and practices involves exhaustively investigating business and engineering activities. Besides data management, organizations also need to look at data visualization and integration when modernizing.

Successful digital transformations use a [data-first strategy][Five reasons a data-first strategy works]. With this approach, organizations focus on the data, rather than the new system. Data management is no longer merely an item on the modernization checklist. Instead, data transformation becomes the centerpiece. Sustainable systems result, as harmonized, quality-oriented data solutions replace fragmented, poorly governed ones.

This reference architecture outlines an end-to-end modernization plan for mainframe and midrange data sources. The solution uses Azure data platform components in a data-first approach. Specifically, it involves:

- Object Conversion: Converting object definitions from the source data store to corresponding objects in the target data store.
- Data Ingestion: Connecting to the source data store and extracting its data.
- Data Transformation: Transforming extracted data to appropriate target data store structures.
- Data Storage: Both initially and continually loading data from the source data store to the target data store.

## Potential use cases

Many organizations can benefit from this solution. Possibilities include mainframe and midrange customers who:

- Need to modernize mission-critical workloads.
- Seek business intelligence to improve operations, enhance processes, or gain a competitive advantage.
- Aim to escape the high costs and rigidity associated with mainframe and midrange data stores.


## Architecture

:::image type="complex" source="./images/migrate-mainframe-data-to-azure.png" alt-text="Architecture diagram showing ..." border="false":::
   Long description.
:::image-end:::

1. The object conversion process extracts object definitions from sources and converts them into corresponding objects on the target data store.
   - [Microsoft SQL Server Migration Assistance (SSMA) for Db2][SQL Server Migration Assistant for Db2] migrates [schemas][Mapping DB2 Schemas to SQL Server Schemas] and data from [IBM Db2 databases][IBM Db2 Database] to SQL Server, [Azure SQL Database][Azure SQL Database], and [Azure SQL Managed Instance][What is Azure SQL Managed Instance?]. A [virtual machine (VM)][Azure virtual machines] hosts SSMA.
   - [Data Provider for Host Files][Data Provider], a component of [Host Integration Server (HIS)][What is HIS], parses [Common Business-Oriented Language (COBOL)][COBOL] and [Report Program Generator (RPG)][RPG] record layouts, or [*copybooks*][COBOL Copybooks overview]. After parsing the copybooks, Data Provider maps them to C# objects that .NET applications can use.
   - For non-relational databases, file systems, and other data stores, third-party tools can perform automated object conversion.

1. Mainframe and midrange systems store data in indexed [Virtual Storage Access Method (VSAM)][VSAM] files and non-indexed [Generation Data Group (GDG)][GDG] files or [flat files][Flat files]. These systems store the files on [Direct Access Storage Devices (DASD) or tape][DASD] in [Extended Binary Coded Decimal Interchange Code (EBCDIC)][EBCDIC] format. COBOL, [Programming Language One (PL/I)][Programming in PL/I], and [assembly language][Assembly language] copybooks define the data structure for these files.
   - The Data Provider host file client can connect remotely to IBM host file system servers. With non-mainframe systems, the client can also read data offline. The client converts data from EBCDIC to [American Standard Code For Information Interchange (ASCII)][ASCII] format based on the provided copybook layout.
   - The solution also works with mainframe and midrange datasets with single layouts and unpacked fields. File Transfer Protocol (FTP) converts and transfers these types of datasets to Azure.

1. Relational databases that are available on IBM mainframe and midrange systems include [Db2 for z/OS][IBM Db2 for z/OS], [Db2 for Linux, UNIX and Windows (Db2 LUW)][IBM Db2 10.5 for Linux, Unix and Windows documentation], and [Db2 for i][IBM Db2 for i].
   - [Azure Data Factory][Azure Data Factory] uses a Db2 connector to extract and integrate data from Db2 for z/OS, Db2 LUW, and Db2 for i.
   - [SQL Server Integration Services (SSIS)][SQL Server Integration Services] performs a broad range of data migration tasks, such as data [extraction, transformation, and loading (ETL)][ETL] tasks.

1. Non-relational databases that IBM mainframe and midrange systems support include the [network model][Network model] Database Management System (DBMS) [Integrated Database Management System (IDMS)][IDMS], the [hierarchical model][Comparison of hierarchical and relational databases] DBMS [Information Management System (IMS)][IMS], and [Datacom][Datacom]. Third-party products are available for integrating data from these databases.

1. Azure offers many managed data storage solutions, each with different features and capabilities:
   - Databases:
   
     - [Azure SQL Database][Azure SQL Database]
     - [Azure SQL Managed Instance][What is Azure SQL Managed Instance?]
     - [Azure Database for PostgreSQL][Azure Database for PostgreSQL]
     - [Azure Database for MySQL][What is Azure Database for MySQL?]
     - [Azure Database for MariaDB][Azure Database for MariaDB documentation]
     - [Azure Cosmos DB][Welcome to Azure Cosmos DB]
     
     Azure services like Data Factory can load data into these databases. You can also use a third-party solution or build a custom loading solution.

   - Storage:
     - [Azure Data Lake Storage][Azure Data Lake Storage]
     - [Azure Storage][Azure Storage]
     
     Azure services like Data Factory and [AzCopy][Get started with AzCopy] can load data into storage. You can also use a third-party solution.

1. A range of [Azure Services][Azure Services overview] can use the modernized data tier for computing, analytics, storage, and networking. With these services, customers can develop and scale new applications or run existing applications in the public cloud.

1. Existing client applications can use the modernized data tier.

1. On-premises Data Gateway: The on-premises data gateway acts as a bridge to provide quick and secure data transfer between on-premises data and Azure services.

## Components

- Networking

  [**On-premises data gateway**][What is an on-premises data gateway?] acts as a bridge that connects on-premises data with cloud services. You typically [install the gateway on a dedicated on-premises VM][Install an on-premises data gateway].

- Data Integrators

  - [Azure Data Factory][Azure Data Factory] is a hybrid data integration service. You can use this fully managed, serverless solution to create, schedule, and orchestrate ETL and [extract-load-transform (ELT)][ELT] workflows.

  - [AzCopy][Get started with AzCopy] is a command-line utility that moves blobs or files into and out of storage accounts.

  - [SSIS][SQL Server Integration Services] is a platform for building enterprise-level data integration and transformation solutions. You can use SSIS to solve complex business problems by copying or downloading files, loading data warehouses, cleansing and mining data, and managing SQL Server objects and data.

- Data Store

  - [Azure Data Lake Storage][Azure Data Lake Storage] is a storage repository that holds a large amount of data in its native, raw format. Data lake stores are optimized for scaling to terabytes and petabytes of data. The data typically comes from multiple, heterogeneous sources and may be structured, semi-structured, or unstructured.

  - [Azure SQL Database][Azure SQL Database] is an intelligent, scalable, relational database service that's built for the cloud. Part of the [Azure SQL family][Azure SQL], Azure SQL Database offers all the benefits of a fully managed and evergreen platform as a service while also providing AI-powered, automated features that optimize performance and durability. Serverless compute and [Hyperscale storage options][Hyperscale service tier] automatically scale resources on demand, so you can focus on building new applications without worrying about storage size or resource management.

  - [Azure Database for PostgreSQL][Azure Database for PostgreSQL] is a fully managed relational database service that's based on the community edition of the open-source [PostgreSQL][PostgreSQL] database engine. With this service, you can focus on application innovation instead of database management. You can also scale your workload quickly and easily.

  - [Azure Database for MySQL][What is Azure Database for MySQL?] is a fully managed relational database service based on the [community edition of the open-source MySQL database engine][MySQL Community Edition].

  - [Azure Database for MariaDB][Azure Database for MariaDB documentation] is a cloud-based relational database service. This service is based on the [MariaDB][MariaDB] community edition database engine.

  - [Azure Cosmos DB][Welcome to Azure Cosmos DB] is a globally distributed, [multi-model][The rise of the multimodel database] database. With Azure Cosmos DB, your solutions can elastically and independently scale throughput and storage across any number of geographic regions. By using this fully managed [NoSQL][What is NoSQL? Databases for a cloud-scale future] database service, you can build and modernize scalable, high-performance applications. Azure Cosmos DB guarantees single-digit millisecond latencies at the ninety-ninth percentile anywhere in the world.

  - [Azure Storage][Azure Storage] is a cloud storage solution that includes object, file, disk, queue, and table storage. Services include hybrid storage solutions and tools for transferring, sharing, and backing up data.

- Tools

  - [SSMA for Db2][SQL Server Migration Assistant for Db2] automates migration from [Db2][IBM Db2 Database] to Microsoft database services. This tool converts Db2 database objects into SQL Server database objects and creates those objects in SQL Server. SSMA for Db2 then migrates data from Db2 to the following services:

    - SQL Server 2012
    - SQL Server 2014
    - SQL Server 2016
    - SQL Server 2017 on Windows and Linux
    - SQL Server 2019 on Windows and Linux
    - Azure SQL Database
    - Azure SQL Managed Instance

  - [Data Provider for Host Files][Data Provider] is a component of HIS that uses offline, [Systems Network Architecture (SNA)][What is Systems Network Architecture (SNA)?], or TCP/IP ([i5/OS][A Brief History of the IBM AS/400 and iSeries] only) connections. In off-line connections, the Data Provider reads and writes records in a local binary file. In SNA and TCP/IP connections, the Data Provider reads and writes records stored in a remote z/OS [(IBM z series Mainframe)][IBM mainframe operating systems] data set or remote i5/OS ([IBM AS/400 and iSeries systems][A Brief History of the IBM AS/400 and iSeries]) physical file.

## Recommendations

Keep the following recommendations in mind when implementing this solution:

- Maybe: [Configure HIS component for performance][Configure HIS component for performance]
- Maybe: [Configure HIS component for security][Data Providers for Host Files Security and Protection]

## Considerations

Keep these points in mind when considering this architecture:

- Maybe: Check the [migration guide][Migration guide].
- Maybe: Third-party products needed for non-relational databases.

## Next steps

- Contact [Azure Data Engineering - Mainframe & Midrange Modernization][Email address for information on Azure Data Engineering Mainframe and Midrange Modernization] for more information.
- Read the [Migration guide][Migration guide].

## Related resources

- [Azure data architecture guide][Azure data architecture guide]
- [Azure data platform end-to-end][Azure data platform end-to-end]

[ASCII]: https://www.britannica.com/topic/ASCII
[Assembly language]: https://www.computerhope.com/jargon/a/al.htm
[Get started with AzCopy]: https://docs.microsoft.com/azure/storage/common/storage-use-azcopy-v10
[Azure data architecture guide]: https://docs.microsoft.com/azure/architecture/data-guide/
[Azure Data Factory]: https://azure.microsoft.com/services/data-factory/
[Azure Data Lake Storage]: https://azure.microsoft.com/services/storage/data-lake-storage/
[Azure data platform end-to-end]: https://docs.microsoft.com/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end
[Azure Database for MariaDB documentation]: https://docs.microsoft.com/azure/mariadb/
[Azure Database for PostgreSQL]: https://azure.microsoft.com/services/postgresql/
[Azure Services overview]: https://azurecharts.com/overview
[Azure SQL]: https://azure.microsoft.com/services/azure-sql/
[Azure SQL Database]: https://azure.microsoft.com/services/sql-database/
[Azure Storage]: https://docs.microsoft.com/azure/storage/
[Azure virtual machines]: https://azure.microsoft.com/services/virtual-machines/
[A Brief History of the IBM AS/400 and iSeries]: https://www.ibm.com/ibm/history/documents/pdf/as400.pdf
[COBOL]: https://developer.ibm.com/languages/cobol/
[COBOL Copybooks overview]: https://www.ibm.com/support/knowledgecenter/en/SSBLQQ_9.2.0/com.ibm.rational.rit.ref.doc/topics/c_ritcobol_test_cobol_schem.html
[Comparison of hierarchical and relational databases]: https://www.ibm.com/support/knowledgecenter/SSEPH2_14.1.0/com.ibm.ims14.doc.apg/ims_comparehierandreldbs.htm
[Configure HIS component for performance]: https://docs.microsoft.com/host-integration-server/core/data-for-host-files#configuringForPerformance
[DASD]: https://www.ibm.com/support/knowledgecenter/zosbasics/com.ibm.zos.zconcepts/zconcepts_74.htm
[Data Provider]: https://docs.microsoft.com/host-integration-server/core/data-for-host-files
[Data Providers for Host Files Security and Protection]: https://docs.microsoft.com/host-integration-server/core/data-providers-for-host-files-security-and-protection
[Datacom]: https://www.broadcom.com/products/mainframe/databases-database-mgmt/datacom
[Email address for information on Azure Data Engineering Mainframe and Midrange Modernization]: mailto:datasqlninja@microsoft.com
[EBCDIC]: https://www.britannica.com/topic/EBCDIC
[ELT]: https://www.ibm.com/cloud/learn/etl#toc-etl-vs-elt-goFgkQcP
[ETL]: https://www.ibm.com/cloud/learn/etl
[Five reasons a data-first strategy works]: https://resources.syniti.com/featured-articles/5-reasons-a-data-first-strategy-works
[Flat files]: https://www.pcmag.com/encyclopedia/term/flat-file
[GDG]: https://www.ibm.com/support/knowledgecenter/zosbasics/com.ibm.zos.zconcepts/zconcepts_175.htm
[Hyperscale service tier]: https://docs.microsoft.com/azure/azure-sql/database/service-tier-hyperscale
[IBM Db2 10.5 for Linux, Unix and Windows documentation]: https://www.ibm.com/support/knowledgecenter/en/SSEPGG_10.5.0/com.ibm.db2.luw.kc.doc/welcome.html
[IBM Db2 Database]: https://www.ibm.com/products/db2-database
[IBM Db2 for i]: https://www.ibm.com/support/pages/ibm-db2-i
[IBM Db2 for z/OS]: https://www.ibm.com/analytics/db2/zos
[IBM mainframe operating systems]: https://www.ibm.com/it-infrastructure/z/os
[IDMS]: https://www.broadcom.com/products/mainframe/databases-database-mgmt/idms
[IMS]: https://www.ibm.com/it-infrastructure/z/ims
[Install an on-premises data gateway]: https://docs.microsoft.com/data-integration/gateway/service-gateway-install
[Mapping DB2 Schemas to SQL Server Schemas]: https://docs.microsoft.com/sql/ssma/db2/mapping-db2-schemas-to-sql-server-schemas-db2tosql
[MariaDB]: https://mariadb.org/
[Migration guide]: https://datamigration.microsoft.com/
[MySQL Community Edition]: https://www.mysql.com/products/community/
[Network model]: https://web.archive.org/web/20060904190944/http://coronet.iicm.edu/wbtmaster/allcoursescontent/netlib/ndm1.htm
[PostgreSQL]: https://www.postgresql.org/
[Programming in PL/I]: https://www.ibm.com/support/knowledgecenter/en/SSGMCP_4.2.0/com.ibm.cics.ts.applicationprogramming.doc/topics/dfhp3_pli_intro.html
[The rise of the multimodel database]: https://www.infoworld.com/article/2861579/the-rise-of-the-multimodel-database.html
[RPG]: https://www.ibm.com/support/knowledgecenter/en/ssw_ibm_i_72/rzahg/rzahgrpgcode.htm
[SQL Server]: https://www.microsoft.com/sql-server/sql-server-2019
[SQL Server Integration Services]: https://docs.microsoft.com/sql/integration-services/sql-server-integration-services
[SQL Server Migration Assistant for Db2]: https://docs.microsoft.com/sql/ssma/db2/sql-server-migration-assistant-for-db2-db2tosql
[VSAM]: https://www.ibm.com/support/knowledgecenter/zosbasics/com.ibm.zos.zconcepts/zconcepts_169.htm
[Welcome to Azure Cosmos DB]: https://docs.microsoft.com/azure/cosmos-db/introduction
[What is an on-premises data gateway?]: https://docs.microsoft.com/data-integration/gateway/service-gateway-onprem
[What is Azure Database for MySQL?]: https://docs.microsoft.com/azure/mysql/overview
[What is Azure SQL Managed Instance?]: https://docs.microsoft.com/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview
[What is HIS]: https://docs.microsoft.com/host-integration-server/what-is-his
[What is NoSQL? Databases for a cloud-scale future]: https://www.infoworld.com/article/3240644/what-is-nosql-databases-for-a-cloud-scale-future.html
[What is Systems Network Architecture (SNA)?]: https://www.ibm.com/support/knowledgecenter/zosbasics/com.ibm.zos.znetwork/znetwork_151.htm





