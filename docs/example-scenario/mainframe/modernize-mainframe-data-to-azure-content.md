[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes an end-to-end modernization plan for mainframe and midrange data sources. Modernization helps improve scalability and performance for mission-critical workloads.

*Apache®, [Spark](https://spark.apache.org), and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="complex" border="false" source="./media/modernize-mainframe-data-azure.svg" alt-text="Diagram that shows the Modernize Mainframe and Midrange Data architecture." lightbox="./media/modernize-mainframe-data-azure.svg":::
   Diagram that shows how to modernize mainframe and midrange systems through data migration to Azure. A dotted line divides the diagram in two halves. The left half is labeled on-premises, and the right half is labeled Azure. On the on-premises side of the diagram, a data store box contains file systems, like Virtual Storage Access Method (VSAM) and flat files, relational databases, like Db2 zOS, and nonrelational databases, like Information Management System (IMS). A dotted arrow points from the data store box to another box, labeled object conversion. This box contains converters like Microsoft SQL Server Migration Assistant for Db2. A dotted arrow connects the object conversion box to a data storage box on the Azure side of the diagram. This arrow shows that object definitions convert into corresponding objects in target data stores like Azure SQL Database and Azure Data Lake Storage. Arrows from the file systems and relational databases connect to a Windows virtual machine (VM) box that contains Azure Data Factory self-hosted integration runtime (IR) and on-premises data gateway, which shows how data is ingested and transformed. The arrows continue to a box that contains FTP and another box that contains SQL Server, Azure Data Factory, and Microsoft Fabric. An arrow connects the nonrelational databases to partner integration solutions. An arrow connects the data ingestion and transformation box with the data storage box. Arrows from the data storage box connect to Azure services and client apps.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/modernize-mainframe-data-azure.vsdx) of this architecture.*

### Data flow

The following data flow corresponds to the previous diagram:

1. Mainframe and midrange systems store data in the following data sources.

   - File systems:

      - Virtual Storage Access Method (VSAM)

      - Flat files

      - Linear Tape File System
      
   - Relational databases:
      
      - Db2 for z/OS

      - Db2 for IBM i

      - Db2 for Linux, Unix, and Windows
      
   - Nonrelational databases:
   
      - Information Management System (IMS)

      - Adabas

      - Integrated Database Management System (IDMS)

1. The object conversion process extracts object definitions from source objects. The process converts the definitions into corresponding objects in the target data store.

   - [Microsoft SQL Server Migration Assistant](/sql/ssma/sql-server-migration-assistant) for Db2 migrates schemas and data from IBM Db2 databases to Azure databases.

   - [Managed Data Provider for Host Files](/host-integration-server/core/managed-data-provider-for-host-files-programmer-s-guide2) converts objects. Managed Data Provider for Host Files:

       - Parses COBOL and Report Program Generator record layouts, or *copybooks*.

       - Maps the copybooks to C# objects that .NET applications use.

   - The [Db2toAzurePostgreSQL](https://techcommunity.microsoft.com/blog/modernizationbestpracticesblog/ai-powered-db2-luw-to-azure-database-for-postgresql-schema-converter/4458436) AI-powered Db2 to PostgreSQL schema converter tool migrates database objects from Db2 to Azure Database for PostgreSQL.

   - Partner tools perform automated object conversion on nonrelational databases, file systems, and other data stores.

1. Data is ingested and transformed. Mainframe and midrange systems store their file system data in EBCDIC-encoded format in file formats like:

   - Indexed [VSAM](https://www.ibm.com/docs/cobol-zos/6.3?topic=files-vsam) files.

   - Nonindexed [Generation Data Group (GDG)](https://www.ibm.com/docs/zos-basic-skills?topic=vtoc-what-is-generation-data-group) files.

   - Flat files
   
     COBOL, PL/I, and assembly language copybooks define the data structure of these files.

   a. FTP transfers mainframe and midrange file system datasets and their corresponding copybooks to Azure. These datasets have single layouts and unpacked fields in binary format.
   
   b. Data conversion uses custom programs that rely on the host file component of Host Integration Server or the built-in connector for IBM host files in Azure Logic Apps.

      The Spark Notebook converter uses open-source Spark frameworks and works with Spark environments such as Microsoft Fabric and Azure Databricks.

   c. The solution migrates relational database data.

      IBM mainframe and midrange systems store data in relational databases like:

      - [Db2 for z/OS](https://www.ibm.com/products/db2-for-zos).

      - [Db2 for Linux, Unix, and Windows](https://www.ibm.com/docs/db2/10.5.0).

      - [Db2 for IBM i](https://www.ibm.com/support/pages/db2-ibm-i).
     
      The following services migrate the database data:

     - Azure Data Factory uses a Db2 connector to extract and integrate data from the databases.

     - SQL Server Integration Services manages data [extract, transform, and load](https://www.ibm.com/think/topics/etl) tasks.

     - Fabric Data Factory uses the IBM Db2 connector to migrate Db2 data.

   d. Nonrelational database data is migrated.
      
      IBM mainframe and midrange systems store data in nonrelational databases, including:

      - [IDMS](https://www.broadcom.com/products/mainframe/databases/idms), a [network model](https://web.archive.org/web/20060904190944/http:/coronet.iicm.edu/wbtmaster/allcoursescontent/netlib/ndm1.htm) database management system (DBMS).

      - [IMS](https://www.ibm.com/products/ims), a [hierarchical model](https://www.ibm.com/docs/ims/14.1.0?topic=ims-comparison-hierarchical-relational-databases) DBMS.

      - [Adabas](https://www.softwareag.com/en/adabas-natural).

      - [Datacom](https://www.broadcom.com/products/mainframe/databases/datacom).
      
      Partner products integrate data from these databases.

1. Azure tools like Azure Data Factory and [AzCopy](https://github.com/Azure/azure-storage-azcopy/wiki/azcopy) load data into Azure databases and Azure data storage. You can also use partner solutions and custom loading solutions to load data.

1. Azure provides various database services, including fully managed relational database services, like Azure SQL Database, and NoSQL options, like Azure Cosmos DB. These services are designed for scalability, flexibility, and global distribution.

   Azure also provides a range of storage solutions, including Azure Blob Storage for unstructured data and Azure Files for fully managed file shares.

1. Azure services use the modernized data tier for computing, analytics, storage, and networking.

1. Client applications also use the modernized data tier.

### Components

This architecture uses the following components.

#### Data storage

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a globally distributed, [multiple-model](/azure/cosmos-db/nosql/modeling-data) database. In this architecture, Azure Cosmos DB serves as a scalable NoSQL target for nonrelational mainframe database modernization.

- [Azure Database for MySQL](/azure/well-architected/service-guides/azure-database-for-mysql) is a fully managed relational database service based on the community edition of the open-source [MySQL](https://www.mysql.com/products/community) database engine. In this architecture, Azure Database for MySQL provides another relational database target option for migrated mainframe data.

- [Azure Database for PostgreSQL](/azure/well-architected/service-guides/postgresql) is a fully managed relational database service based on the community edition of the open-source [PostgreSQL](https://www.postgresql.org) database engine. In this architecture, Azure Database for PostgreSQL provides an alternative target database for mainframe relational data migration.

- [SQL Database](/azure/well-architected/service-guides/azure-sql-database) is a fully managed, cloud-based platform as a service. SQL Database provides AI-powered automated features that optimize performance and durability. Serverless compute and [Hyperscale storage options](/azure/azure-sql/database/service-tier-hyperscale) autoscale resources on demand. In this architecture, SQL Database serves as a target database for migrated relational data from mainframe Db2 systems.

- [Azure SQL Managed Instance](/azure/well-architected/service-guides/azure-sql-managed-instance) is a fully managed cloud database service. SQL Managed Instance supports most SQL Server Enterprise features, and it provides a native virtual network implementation that addresses common security concerns. In this architecture, SQL Managed Instance serves as a target for mainframe data that requires SQL Server compatibility and enterprise features.

- [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) is a storage repository that holds large amounts of native and raw data. Data lake stores are optimized for scaling to terabytes and petabytes of data. The data typically comes from multiple heterogeneous sources, and it can be structured, semistructured, or unstructured. In this architecture, Data Lake Storage provides scalable storage for converted mainframe file system data and serves as a staging area for data transformation.

- A [Fabric lakehouse](/fabric/data-engineering/lakehouse-overview) is a data architecture platform for the storage, management, and analysis of structured and unstructured data in a single location. In this architecture, a Fabric Lakehouse serves as a unified analytics platform for raw mainframe data and processed datasets.

- [SQL database in Fabric](/fabric/database/sql/overview) is a developer-friendly transactional database based on SQL Database. You can use it to create your operational database in Fabric. SQL database in Fabric uses the same SQL database engine as SQL Database. In this architecture, a SQL database in Fabric provides a modern transactional database option for migrated mainframe operational data.

#### Compute

- [Azure Data Factory](/azure/data-factory/introduction) is a cloud-based data integration service that integrates data across different network environments by using an [integration runtime (IR)](/azure/data-factory/concepts-integration-runtime), which is a compute infrastructure. Azure Data Factory copies data between cloud data stores and data stores in on-premises networks by using [self-hosted IRs](/azure/data-factory/concepts-integration-runtime#self-hosted-integration-runtime). In this architecture, Azure Data Factory manages data migration from mainframe sources to Azure targets.

- The [on-premises data gateway](/data-integration/gateway/service-gateway-onprem) is a locally installed Windows client application that serves as a bridge between local data sources and Microsoft Cloud services. In this architecture, the on-premises data gateway establishes secure connectivity between mainframe systems and Azure services.

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is an infrastructure as a service (IaaS) that provides on-demand, scalable computing resources. Azure virtual machines (VMs) provide virtualization flexibility but eliminate the maintenance demands of physical hardware. Azure VMs are compatible with operating systems like Windows and Linux. In this architecture, Virtual Machines hosts migration tools, like SQL Server Migration Assistant for Db2, and custom conversion applications.

#### Data integrators

- Azure Data Factory is a hybrid data integration service. Azure Data Factory migrates data from Db2 sources to Azure database targets by using native connectors. In this architecture, Azure Data Factory serves as the primary data integration service for mainframe data migration workflows.

- [AzCopy](/azure/storage/common/storage-use-azcopy-v10) is a command-line utility that moves blobs or files into and out of storage accounts. In this architecture, AzCopy transfers large volumes of mainframe file system data to Azure Storage during the migration process.

- [SQL Server Integration Services](/sql/integration-services/sql-server-integration-services) is a platform for creating enterprise-level data integration and transformation solutions. In this architecture, use it to perform data transformation tasks during mainframe migration, such as:

   - Copying or downloading files.

   - Data warehouse loading.

   - Data cleansing and data mining.

   - Management of SQL Server objects and data.

- [Host Integration Server](/host-integration-server/what-is-his) technologies and tools can integrate existing IBM host systems, programs, messages, and data with Azure applications. The host file client component provides flexibility for data converted from EBCDIC to ASCII. For example, you can generate data in JSON or XML format from the converted data. In this architecture, Host Integration Server converts EBCDIC-encoded mainframe data to ASCII format for Azure consumption.

- [Azure Databricks](/azure/databricks/introduction/) is a data analytics platform. Azure Databricks is based on the Apache Spark open-source distributed processing system, and it's optimized for the Azure cloud platform. In an analytics workflow, Azure Databricks reads data from multiple sources and uses Spark to provide insights.

- Fabric is an enterprise-ready, end-to-end analytics platform. It unifies data movement, data processing, ingestion, transformation, real-time event routing, and report building. Fabric supports these capabilities by using the following integrated services:

   - Fabric Data Engineering

   - Fabric Data Factory

   - Fabric Data Science

   - Fabric Real-Time Intelligence

   - Fabric Data Warehouse

   - Fabric Databases

In this architecture, Fabric provides a comprehensive analytics platform for end-to-end mainframe data modernization and business intelligence.

#### Other tools

- [SQL Server Migration Assistant for Db2](/sql/ssma/db2/sql-server-migration-assistant-for-db2-db2tosql) automates migration from Db2 to Microsoft database services. On a VM, SQL Server Migration Assistant for Db2 converts Db2 database objects into SQL Server database objects and creates those objects in SQL Server. In this architecture, SQL Server Migration Assistant for Db2 autoconverts mainframe Db2 database schemas and objects to Azure database targets.

- [Data Provider for Host Files](/host-integration-server/core/data-for-host-files) is a component of Host Integration Server that uses offline, Systems Network Architecture (SNA), or TCP/IP connections.

   - **Offline connections.** Data Provider reads and writes records in a local binary file.

   - **SNA connections.** Data Provider reads and writes records stored in remote z/OS (IBM Z series mainframe) datasets or remote i5/OS (IBM AS/400 and iSeries systems) physical files.
   
   - **TCP/IP connections.** Only i5/OS systems use TCP/IP connections.

   In this architecture, Data Provider for Host Files provides connectivity and data access between mainframe file systems and Azure applications.

- [Azure services](https://azurecharts.com/overview) provide environments, tools, and processes for new application development and scaling in the public cloud. In this architecture, Azure services provide the target cloud platform for modernized mainframe applications and data analytics workloads.

## Scenario details

Modern data storage solutions, like the Azure data platform, provide better scalability and performance than mainframe and midrange systems. You can access these benefits if you upgrade your system, but it can be complicated to update technology, infrastructure, and procedures. Conduct an exhaustive investigation of your organization's business and engineering activities. Consider your data management, data visualization, and data integration procedures.

Successful modernizations use a [data-first strategy](https://www.enterpriseappstoday.com/data-management/5-reasons-a-data-first-strategy-works.html). This approach focuses on the data rather than the new system, which makes data management the centerpiece of your modernization strategy. Replace fragmented, poorly governed data solutions with a coordinated, quality-oriented strategy.

This solution uses Azure data platform components in a data-first approach. Specifically, the solution involves:

- **Object conversion.** Convert object definitions from the source data store to corresponding objects in the target data store.
- **Data ingestion.** Connect to the source data store and extract data.
- **Data transformation.** Transform extracted data into appropriate target data store structures.
- **Data storage.** Initially and continually load data from the source data store to the target data store.
 
### Potential use cases

You can benefit from this solution if you want to:

- Modernize business-critical workloads.
- Acquire business intelligence to improve operations and gain a competitive advantage.
- Remove the high costs and rigidity that are associated with mainframe and midrange data stores.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Ashish Khandelwal](https://www.linkedin.com/in/ashish-khandelwal-839a851a3) | Principal Engineering Architect Manager

Other contributors:

- [Nithish Aruldoss](https://www.linkedin.com/in/nithish-aruldoss-b4035b2b) | Engineering Architect
- [Rodrigo Rodríguez](https://www.linkedin.com/in/rod2k10/) | Senior Cloud Solution Architect, AI & Quantum

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

- [Azure Database Migration Guides](/data-migration)

## Related resource

- [Analytics end to end with Fabric](../../example-scenario/dataplate2e/data-platform-end-to-end.yml)
