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

Azure Data Platform and other [what does it do] systems offer improved scalability and performance over mainframe and midrange systems. However, modernizing/updating technology, infrastructure, and practices involves exhaustively investigating engineering and business activities. Besides data management, the modernization process involves data visualization and integration.

Successful digital transformations use a data-first strategy. what is data-first and why is it successful

This reference architecture outlines an end-to-end modernization solution for mainframe and midrange data sources that uses Azure Data Platform as teh target data store. The following processes are involved:

- Object Conversion: This involves converting object definitions from source data store to corresponding objects on the target data store.
- Data Ingestion: This involves connecting and extracting data from the source data store.
- Data Transformation: This involves transforming extracted data to required target data store structure.
- Data Storage: This involves initial, continuous data loading from source data store to target data store.


what is data management:
what is data visualization:
what is data integration across an organization’s wider ecosystem. 

In majority of scenarios we are observing that data first strategy is a foundational step towards any successful digital transformation.



This reference architecture outlines various technical aspects for modernizing Mainframe & Midrange data store with improving scalability and performance in an Azure Data Platform. It consists of following processes.

Cut:
data-first is best strategy. This solution does it.

The process of modernizing mainframe and midrange systems involves data management, data visualization, and data integration. Successful digital transformations use a data-first strategy. what is data-first and why is it successful

Maybe explain benefits of modernization here: switching from mainframe and midrange systems to Azure Data Platform offers many benefits. 

In order to reap benefits of cutting-edge technologies, users of mainframe and midrange systems seek to modernize their systems. However, updating technology, infrastructure, and practices involves exhaustively investigating engineering and business activities.

## Potential use cases

Mainframe & Midrange Modernization use cases that can benefit from this solution are:
IBM Mainframe & Midrange customers who need to modernize mission-critical workloads.
Need business intelligence to improve operations, enhance business processes or gain competitive advantages.
Escape the high costs and rigidity associated with Mainframe & Midrange data stores. 


## Architecture

:::image type="complex" source="./images/migrate-mainframe-data-to-azure.png" alt-text="Architecture diagram showing the flow of events in an ingestion pipeline. Events flow from producers to a cluster or namespace and then to consumers." border="false":::
   At the center of the diagram is a box labeled Kafka Cluster or Event Hub Namespace. Three smaller boxes sit inside that box. Each is labeled Topic or Event Hub, and each contains multiple rectangles labeled Partition. Above the main box are rectangles labeled Producer. Arrows point from the producers to the main box. Below the main box are rectangles labeled Consumer. Arrows point from the main box to the consumers and are labeled with various offset values. A single blue frame labeled Consumer Group surrounds two of the consumers, grouping them together.
:::image-end:::

1. Object Conversion: Converting objects involves extracting object definitions from sources and converts them to corresponding objects on the target data store. 
   1. SQL Server Migration Assistance for Db2 is a tool to automate migration from IBM DB2 database(s) to SQL Server, Azure SQL Database and Azure SQL Database Managed Instance. This tool can also help in Db2 schema assessment. It is used for Schema migration. It can also be used for data migration based upon the data types and database size.  SSMA will be hosted on a Virtual machine.
   1. Host File Client (HFC) which is a component of Host Integration server(HIS) is first party product which parse the COBOL and RPG copybooks (record layout) and create mapping C# object to be used in .NET applications.
   1. 3rd party tools can be used for Automated object conversion for non-relational databases (e.g. IMS, IDMS) and file Systems data stores. 
1. File Systems: Mainframe and Midrange systems can have Indexed (e.g. VSAM) and Non-Indexed (e.g. GDG, Flat Files) files which are stored on DASD or Tape in EBCDIC format. Data structure for these files are generally defined in COBOL/PL1/ Assembler layouts called as copybooks.
   1. HFC connects remotely to IBM host file system servers (online), or can read data offline from non-mainframe system. It converts data from EBCDIC to ASCII format based on copybook layout provided. 
   1. FTP can be used to convert and transfer Mainframe & Midrange dataset with single layout and unpacked fields to Azure.
1. Relational Databases:  Db2 for zOS, Db2 LUW and Db2 for i are relational databases available on IBM Mainframe and Midrange systems.
   1. Azure Data Factory (ADF) has Db2 connector and can be used to pull data from Db2 (zOS, LUW or Db2 for i). It is cloud ETL service for scale-out serverless data integration and data transformation.
   1. SQL Server Integration Services (SSIS) can be used to perform a broad range of data migration tasks. It is used for data extraction, transformation, and loading (ETL). 
1. Non-Relational Databases: Non-relational databases are supported by IBM Mainframe & Midrange system Example of these databases are – IDMS (Network DBMS), IMS (Hierarchical DBMS), Datacom etc. Data from non-relational databases can be sync through third party solutions available. 
1. Data Storage: Azure offers many managed data storage solutions, each providing different features and capabilities.
   1. Databases: Azure SQL DB, Azure SQL MI, Azure database for PostgreSQL, Azure database for MySQL, Azure CosmosDB. Data can be loaded to these databases using Azure services like ADF, 3rd party solutions or building custom loading solution. 
   1. Storage: Azure data Lake Store, Azure storage. Data can be loaded in storage using azure services like ADF, AZ Copy or using 3rd party solutions which can connect to storage. 
1. Azure Services: Modernized data tier can be used by range of Azure services, including compute, analytics, storage, and networking. Customers can pick and choose from these services to develop and scale new applications or run existing applications in the public cloud.
1. Client Apps: Existing client applications can run using modernized data tier.
1. On-premises Data Gateway: The on-premises data gateway acts as a bridge to provide quick and secure data transfer between on-premises data and Azure services. By using a gateway, organizations can migrate data from on-prem to Azure.

## Components

- Networking

  On-premises data gateway. An on-premises data gateway is bridge software that connects on-premises data to cloud services. The gateway typically installs on a dedicated on-premises virtual machine.

- Data Integrators

  - Azure Data Factory -is a hybrid data integration service that allows you to create, schedule and orchestrate your ETL/ELT workflows.

  - SQL Server Integration Services - SQL Server Integration Services is a platform for building enterprise-level data integration and data transformations solutions. Use Integration Services to solve complex business problems by copying or downloading files, loading data warehouses, cleansing and mining data, and managing SQL Server objects and data.

- Data Store

  - Azure Data Lake Storage - Data lake is a storage repository that holds a large amount of data in its native, raw format. Data lake stores are optimized for scaling to terabytes and petabytes of data. The data typically comes from multiple heterogeneous sources, and may be structured, semi-structured, or unstructured.

  - Azure SQL Database - Part of the Azure SQL family, Azure SQL Database is the intelligent, scalable, relational database service built for the cloud. It’s evergreen and always up to date, with AI-powered and automated features that optimize performance and durability for you. Serverless compute and Hyperscale storage options automatically scale resources on demand, so you can focus on building new applications without worrying about storage size or resource management.

  - Azure Database for PostgreSQL is a fully managed relational database service based on the community edition of the open-source PostgreSQL database engine. Let’s you focus on application innovation instead of database management and scale your workload quickly and easily.

  - Azure Database for MySQL is a fully managed relational database service based on the community edition of the open-source MySQL database engine.

  - Azure Cosmos DB  is Microsoft's globally distributed, multi-model database that enables your solutions to elastically and independently scale throughput and storage across any number of geographic regions. It is a fully managed NoSQL database service for building and modernizing scalable, high performance applications. Cosmos DB guarantees single-digit-millisecond latencies at the 99th percentile anywhere in the world.

- Tools

  - Microsoft SQL Server Migration Assistant (SSMA) for DB2 is a tool for migrating DB2 databases to Microsoft SQL Server 2012, Microsoft SQL Server 2014, Microsoft SQL Server 2016, Microsoft SQL Server 2017 on Windows and Linux, Microsoft SQL Server 2019 on Windows and Linux, or Azure SQL Database. SSMA for DB2 converts DB2 database objects to SQL Server database objects, creates those objects in SQL Server, and then migrates data from DB2 to SQL Server or Azure SQL Database.

  - Host Integration Server (HIS)  Data Provider for Host Files (Host File Client) is the component of HIS. The Data Provider for Host File client uses off-line, SNA, or TCP/IP (i5/OS only) connections. In off-line connections, the Data Provider reads and writes records in a local binary file. In SNA and TCP/IP connections, the Data Provider reads and writes records stored in a remote z/OS (IBM z series Mainframe) data set or remote i5/OS (IBM i-Series/ AS400 systems) physical file.

## Recommendations

Keep the following recommendations in mind when developing a partitioning strategy.

## Considerations

Keep these points in mind when using a partitioning model.

### Scalability considerations


### Availability considerations


### Performance considerations


### Security considerations



## Next steps

- Contact [Azure Data Engineering - Mainframe & Midrange Modernization][Email address for information on Azure Data Engineering Mainframe and Midrange Modernization] for more information.
- Read the [Migration guide][Migration guide].


## Related resources

[Azure data architecture guide][Azure data architecture guide]
[Azure data platform end-to-end][Azure data platform end-to-end]


[Azure data architecture guide]: https://docs.microsoft.com/azure/architecture/data-guide/
[Azure data platform end-to-end]: https://docs.microsoft.com/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end
[Email address for information on Azure Data Engineering Mainframe and Midrange Modernization]: mailto:datasqlninja@microsoft.com
[Migration guide]: https://datamigration.microsoft.com/