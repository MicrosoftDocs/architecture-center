---
title: Migrate mainframe + midrange data to Azure
author: JKirsch1
ms.date: 11/02/2020
description: Learn about partitioning in Kafka and Event Hubs with Kafka. See how many partitions to use in ingestion pipelines and how to assign events to partitions.
ms.custom: fcp
ms.service: architecture-center
ms.category:
  - migration
ms.subservice: reference-architecture
---

# Migrate mainframe and midrange data to Azure

Present-day data store solutions like the Azure data platform offer improved scalability and performance over mainframe and midrange systems. However, updating technology, infrastructure, and practices involves exhaustively investigating business and engineering activities. Besides data management, organizations also need to look at data visualization and integration when modernizing.

Successful digital transformations use a [data-first strategy][Five reasons a data-first strategy works]. With this approach, organizations focus on the data as a first step, rather than on the new system. Data management is no longer merely an item on the modernization checklist. Instead, data transformation becomes the centerpiece. Sustainable systems result, as harmonized, quality-oriented data solutions replace fragmented, poorly governed ones.

This reference architecture outlines an end-to-end modernization plan for mainframe and midrange data sources. The solution uses Azure data platform components in a data-first approach. Specifically, it involves:

- Object Conversion: Converting object definitions from the source data store to corresponding objects on the target data store.
- Data Ingestion: Connecting to the source data store and extracting its data.
- Data Transformation: Transforming extracted data to appropriate target data store structures.
- Data Storage: Both initially and continually loading data from the source data store to the target data store.

## Potential use cases

Many organizations can benefit from this solution. Possibilities include mainframe and midrange customers who:

- Need to modernize mission-critical workloads.
- Seek business intelligence to improve operations, enhance processes, or gain a competitive advantage.
- Aim to escape the high costs and rigidity associated with mainframe and midrange data stores.


## Architecture

:::image type="complex" source="./images/migrate-mainframe-data-to-azure.png" alt-text="Architecture diagram showing the flow of events in an ingestion pipeline. Events flow from producers to a cluster or namespace and then to consumers." border="false":::
   At the center of the diagram is a box labeled Kafka Cluster or Event Hub Namespace. Three smaller boxes sit inside that box. Each is labeled Topic or Event Hub, and each contains multiple rectangles labeled Partition. Above the main box are rectangles labeled Producer. Arrows point from the producers to the main box. Below the main box are rectangles labeled Consumer. Arrows point from the main box to the consumers and are labeled with various offset values. A single blue frame labeled Consumer Group surrounds two of the consumers, grouping them together.
:::image-end:::

1. Object Conversion: This process extracts object definitions from sources and converts them to corresponding objects on the target data store.
   1. [Microsoft SQL Server Migration Assistance (SSMA) for Db2][SQL Server Migration Assistant for Db2] is a tool that automates migration from [IBM Db2 databases][IBM Db2 Database] to SQL Server, Azure SQL Database and Azure SQL Database Managed Instance. This tool can also help in Db2 schema assessment. It is used for Schema migration. It can also be used for data migration based upon the data types and database size.  SSMA will be hosted on a [virtual machine (VM)][Azure virtual machines].
   1. [Data Provider for Host Files][Data Provider], a component of [Host Integration Server (HIS)][What is HIS], parses [Common Business-Oriented Language (COBOL)][COBOL] and [Report Program Generator (RPG)][RPG] record layouts, known as [*copybooks*][COBOL Copybooks overview], and maps them to C# objects that .NET applications can use.
   1. 3rd party tools can be used for Automated object conversion for non-relational databases (e.g. IMS, IDMS) and file Systems data stores. 
1. File Systems: Mainframe and Midrange systems can have Indexed (e.g. VSAM) and Non-Indexed (e.g. GDG, Flat Files) files which are stored on DASD or Tape in EBCDIC format. Data structure for these files are generally defined in COBOL/PL1/ Assembler layouts called as copybooks.
   1. The Data Provider host file client can connect remotely to IBM host file system servers or can read data offline from non-mainframe systems. The client converts data from [Extended Binary Coded Decimal Interchange Code (EBCDIC)][EBCDIC] to [American Standard Code For Information Interchange (ASCII)][ASCII] format based on the provided copybook layout.
   1. FTP can be used to convert and transfer Mainframe & Midrange dataset with single layout and unpacked fields to Azure.
1. Relational Databases:  Db2 for zOS, Db2 LUW and Db2 for i are relational databases available on IBM Mainframe and Midrange systems.
   1. Azure Data Factory (ADF) has Db2 connector and can be used to pull data from Db2 (zOS, LUW or Db2 for i). It is a cloud [extract-transform-load (ETL)][ETL] service for scale-out serverless data integration and data transformation.
   1. [SQL Server Integration Services (SSIS)][SQL Server Integration Services] can be used to perform a broad range of data migration tasks. It is used for data extraction, transformation, and loading (ETL). 
1. Non-Relational Databases: Non-relational databases are supported by IBM Mainframe & Midrange system Example of these databases are – IDMS (Network DBMS), IMS (Hierarchical DBMS), Datacom etc. Data from non-relational databases can be sync through third party solutions available. 
1. Data Storage: Azure offers many managed data storage solutions, each providing different features and capabilities.
   1. Databases: Azure SQL DB, Azure SQL MI, Azure database for PostgreSQL, Azure database for MySQL, Azure CosmosDB. Data can be loaded to these databases using Azure services like ADF, 3rd party solutions or building custom loading solution. 
   1. Storage: Azure data Lake Store, Azure storage. Data can be loaded in storage using azure services like ADF, AZ Copy or using 3rd party solutions which can connect to storage. 
1. Azure Services: Modernized data tier can be used by range of Azure services, including compute, analytics, storage, and networking. Customers can pick and choose from these services to develop and scale new applications or run existing applications in the public cloud.
1. Client Apps: Existing client applications can run using modernized data tier.
1. On-premises Data Gateway: The on-premises data gateway acts as a bridge to provide quick and secure data transfer between on-premises data and Azure services. By using a gateway, organizations can migrate data from on-prem to Azure.

## Components

- Networking

  [**On-premises data gateway**][What is an on-premises data gateway?] acts as a bridge that connects on-premises data with cloud services. You typically [install the gateway on a dedicated on-premises VM][Install an on-premises data gateway].

- Data Integrators

  - [Azure Data Factory][Azure Data Factory] is a hybrid data integration service that you can use to create, schedule, and orchestrate ETL and [extract-load-transform (ELT)][ELT] workflows.

  - [SSIS][SQL Server Integration Services] is a platform for building enterprise-level data integration and transformation solutions. You can use SSIS to solve complex business problems by copying or downloading files, loading data warehouses, cleansing and mining data, and managing SQL Server objects and data.

- Data Store

  - [Azure Data Lake Storage][Azure Data Lake Storage] is a storage repository that holds a large amount of data in its native, raw format. Data lake stores are optimized for scaling to terabytes and petabytes of data. The data typically comes from multiple, heterogeneous sources and may be structured, semi-structured, or unstructured.

  - [Azure SQL Database][Azure SQL Database] is an intelligent, scalable, relational database service that's built for the cloud. Part of the [Azure SQL family][Azure SQL], Azure SQL Database is evergreen and always up to date, with AI-powered and automated features that optimize performance and durability. Serverless compute and [Hyperscale storage options][Hyperscale service tier] automatically scale resources on demand, so you can focus on building new applications without worrying about storage size or resource management.

  - [Azure Database for PostgreSQL][Azure Database for PostgreSQL] is a fully managed relational database service that's based on the community edition of the open-source [PostgreSQL][PostgreSQL] database engine. With this service, you can focus on application innovation instead of database management. You can also scale your workload quickly and easily.

  - [Azure Database for MySQL][What is Azure Database for MySQL?] is a fully managed relational database service based on the [community edition of the open-source MySQL database engine][MySQL Community Edition].

  - [Azure Cosmos DB][Welcome to Azure Cosmos DB] is a globally distributed, [multi-model][The rise of the multimodel database] database. With Azure Cosmos DB, your solutions can elastically and independently scale throughput and storage across any number of geographic regions. By using this fully managed [NoSQL][What is NoSQL? Databases for a cloud-scale future] database service, you can build and modernize scalable, high-performance applications. Azure Cosmos DB guarantees single-digit millisecond latencies at the ninety-ninth percentile anywhere in the world.

- Tools

  - [SSMA for Db2][SQL Server Migration Assistant for Db2] automates migration from [Db2][IBM Db2 Database] to Microsoft database services. This tool converts Db2 database objects into SQL Server database objects and creates those objects in SQL Server. SSMA for Db2 then migrates data from Db2 to the following services:

    - SQL Server 2012
    - SQL Server 2014
    - SQL Server 2016
    - SQL Server 2017 on Windows and Linux
    - SQL Server 2019 on Windows and Linux
    - Azure SQL Database

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
[Azure data architecture guide]: https://docs.microsoft.com/azure/architecture/data-guide/
[Azure Data Factory]: https://azure.microsoft.com/services/data-factory/
[Azure Data Lake Storage]: https://azure.microsoft.com/services/storage/data-lake-storage/
[Azure data platform end-to-end]: https://docs.microsoft.com/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end
[Azure Database for PostgreSQL]: https://azure.microsoft.com/services/postgresql/
[Azure SQL]: https://azure.microsoft.com/services/azure-sql/
[Azure SQL Database]: https://azure.microsoft.com/services/sql-database/
[Azure virtual machines]: https://azure.microsoft.com/services/virtual-machines/
[A Brief History of the IBM AS/400 and iSeries]: https://www.ibm.com/ibm/history/documents/pdf/as400.pdf
[COBOL]: https://developer.ibm.com/languages/cobol/
[COBOL Copybooks overview]: https://www.ibm.com/support/knowledgecenter/en/SSBLQQ_9.2.0/com.ibm.rational.rit.ref.doc/topics/c_ritcobol_test_cobol_schem.html
[Configure HIS component for performance]: https://docs.microsoft.com/host-integration-server/core/data-for-host-files#configuringForPerformance
[Data Provider]: https://docs.microsoft.com/host-integration-server/core/data-for-host-files
[Data Providers for Host Files Security and Protection]: https://docs.microsoft.com/host-integration-server/core/data-providers-for-host-files-security-and-protection
[Email address for information on Azure Data Engineering Mainframe and Midrange Modernization]: mailto:datasqlninja@microsoft.com
[EBCDIC]: https://www.britannica.com/topic/EBCDIC
[ELT]: https://www.ibm.com/cloud/learn/etl#toc-etl-vs-elt-goFgkQcP
[ETL]: https://www.ibm.com/cloud/learn/etl
[Five reasons a data-first strategy works]: https://resources.syniti.com/featured-articles/5-reasons-a-data-first-strategy-works
[Hyperscale service tier]: https://docs.microsoft.com/azure/azure-sql/database/service-tier-hyperscale
[IBM Db2 Database]: https://www.ibm.com/products/db2-database
[IBM mainframe operating systems]: https://www.ibm.com/it-infrastructure/z/os
[Install an on-premises data gateway]: https://docs.microsoft.com/data-integration/gateway/service-gateway-install
[Migration guide]: https://datamigration.microsoft.com/
[MySQL Community Edition]: https://www.mysql.com/products/community/
[PostgreSQL]: https://www.postgresql.org/
[The rise of the multimodel database]: https://www.infoworld.com/article/2861579/the-rise-of-the-multimodel-database.html
[RPG]: https://www.ibm.com/support/knowledgecenter/en/ssw_ibm_i_72/rzahg/rzahgrpgcode.htm
[SQL Server Integration Services]: https://docs.microsoft.com/sql/integration-services/sql-server-integration-services
[SQL Server Migration Assistant for Db2]: https://docs.microsoft.com/sql/ssma/db2/sql-server-migration-assistant-for-db2-db2tosql
[Welcome to Azure Cosmos DB]: https://docs.microsoft.com/azure/cosmos-db/introduction
[What is an on-premises data gateway?]: https://docs.microsoft.com/data-integration/gateway/service-gateway-onprem
[What is Azure Database for MySQL?]: https://docs.microsoft.com/azure/mysql/overview
[What is HIS]: https://docs.microsoft.com/host-integration-server/what-is-his
[What is NoSQL? Databases for a cloud-scale future]: https://www.infoworld.com/article/3240644/what-is-nosql-databases-for-a-cloud-scale-future.html
[What is Systems Network Architecture (SNA)?]: https://www.ibm.com/support/knowledgecenter/zosbasics/com.ibm.zos.znetwork/znetwork_151.htm
