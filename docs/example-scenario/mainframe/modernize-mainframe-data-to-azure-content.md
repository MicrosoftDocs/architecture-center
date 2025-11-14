*Apache®, [Spark](https://spark.apache.org), and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

This article describes an end-to-end modernization plan for mainframe and midrange data sources. Modernization helps improve scalability and performance for your mission-critical workloads.

## Architecture

:::image type="complex" source="./media/modernize-mainframe-data-azure.svg" alt-text="Architecture diagram that shows how to modernize mainframe and midrange systems by migrating data to Azure." border="false" lightbox="./media/modernize-mainframe-data-azure.svg":::
   The diagram shows how to modernize mainframe and midrange systems by migrating data to Azure. A dotted line divides the diagram in two halves. The left half is labeled on-premises, and the right half is labeled Azure. In the on-premises half, a data store box contains file systems, like VSAM flat files, relational databases, like Db2 zOS, and nonrelational databases, like IMS. A dotted arrow points from the data store box to another box labeled object conversion. This box contains converters like SQL Server Migration Assistant for Db2. A dotted arrow connects the object conversion box to a data storage box on the Azure side of the diagram. It represents how object definitions are converted into corresponding objects in target data stores like Azure SQL Database and Azure Data Lake Storage. Arrows from the file systems and relational databases connect to Azure self-hosted integration runtime and on-premises data gateway show how data is ingested and transformed. The arrows continue to a box that contains File Transfer Protocol and another box that contains SQL Server, Azure Data Factory, and Microsoft Fabric. An arrow connects the nonrelational databases to partner integration solutions. An arrow connects the data ingestion and transformation box with the data storage box. Finally, arrows from the data storage box connect to Azure services and client apps.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/modernize-mainframe-data-azure.vsdx) of this architecture.*

### Dataflow

The following dataflow corresponds to the previous diagram:

1. Mainframe and midrange systems store data in the following data sources.

   - File systems:

      - Virtual Storage Access Method (VSAM)
      - Flat files
      - Linear Tape File System
      
   - Relational databases:
      
      - Db2 for z/OS
      - Db2 for IBM i
      - Db2 for Linux UNIX and Windows
      
   - Nonrelational databases:
   
      - Information Management System (IMS)
      - Adabas
      - Integrated Database Management System (IDMS)

1. The object conversion process extracts object definitions from source objects. The definitions are then converted into corresponding objects in the target data store.

   - [SQL Server Migration Assistant](/sql/ssma/sql-server-migration-assistant) for Db2 migrates schemas and data from IBM Db2 databases to Azure databases.

   - [Managed Data Provider for Host Files](/host-integration-server/core/managed-data-provider-for-host-files-programmer-s-guide2) converts objects by:

       - Parsing common business-oriented language (COBOL) and Report Program Generator record layouts, or *copybooks*.
       - Mapping the copybooks to C# objects that .NET applications use.

   - The [Db2toAzurePostgreSQL](https://techcommunity.microsoft.com/blog/modernizationbestpracticesblog/converting-database-objects-from-db2-to-azure-database-for-postgresql/4162828) tool migrates database objects from Db2 to Azure Database for PostgreSQL.

   - Partner tools perform automated object conversion on nonrelational databases, file systems, and other data stores.

1. Data is ingested and transformed. Mainframe and midrange systems store their file system data in EBCDIC-encoded format in file formats like:

   - Indexed [VSAM](https://www.ibm.com/docs/cobol-zos/6.3?topic=files-vsam) files.
   - Nonindexed [GDG](https://www.ibm.com/support/knowledgecenter/zosbasics/com.ibm.zos.zconcepts/zconcepts_175.htm) files.
   - Flat files.
   
    COBOL, Programming Language One, and assembly language copybooks define the data structure of these files.

   a. File Transfer Protocol (FTP) transfers mainframe and midrange file system datasets and their corresponding copybooks to Azure. These datasets have single layouts and unpacked fields in binary format.
   
   b. Data conversion is accomplished by developing custom programs by using the host file component of Host Integration Server or by using the built-in connector for IBM host files in Azure Logic Apps.

      The Spark Notebook converter is developed by using open-source Spark frameworks. It's compatible with Spark environments such as Microsoft Fabric and Azure Databricks.

   c. Relational database data is migrated.

      IBM mainframe and midrange systems store data in relational databases like:

      - [Db2 for z/OS](https://www.ibm.com/products/db2-for-zos).
      - [Db2 for Linux UNIX and Windows](https://www.ibm.com/support/knowledgecenter/en/SSEPGG_10.5.0/com.ibm.db2.luw.kc.doc/welcome.html).
      - [Db2 for IBM i](https://www.ibm.com/support/pages/db2-ibm-i).
     
      The following services migrate the database data:

     - Azure Data Factory uses a Db2 connector to extract and integrate data from the databases.
     - SQL Server Integration Services handles various data [extract, transform, and load](https://www.ibm.com/cloud/learn/etl) tasks.
     - Fabric Data Factory uses the IBM Db2 connector to migrate Db2 data.

   d. Nonrelational database data is migrated.
      
      IBM mainframe and midrange systems store data in nonrelational databases like:

      - [IDMS](https://www.broadcom.com/products/mainframe/databases-database-mgmt/idms), a [network model](https://web.archive.org/web/20060904190944/http:/coronet.iicm.edu/wbtmaster/allcoursescontent/netlib/ndm1.htm) database management system (DBMS).
      - [IMS](https://www.ibm.com/it-infrastructure/z/ims), a [hierarchical model](https://www.ibm.com/support/knowledgecenter/SSEPH2_14.1.0/com.ibm.ims14.doc.apg/ims_comparehierandreldbs.htm) DBMS.
      - [Adabas](https://www.softwareag.com/en_corporate/platform/adabas-natural.html).
      - [Datacom](https://www.broadcom.com/products/mainframe/databases-database-mgmt/datacom).
      
      Partner products integrate data from these databases.

1. Azure tools like Azure Data Factory and [AzCopy](/azure/storage/common/storage-ref-azcopy) load data into Azure databases and Azure data storage. You can also use partner solutions and custom loading solutions to load data.

1. Azure provides various database services, including fully managed relational database services like Azure SQL Database and NoSQL options like Azure Cosmos DB. These services are designed for scalability, flexibility, and global distribution.

   Azure also provides a range of storage solutions, including Azure Blob Storage for unstructured data and Azure Files for fully managed file shares.

1. Azure services use the modernized data tier for computing, analytics, storage, and networking.

1. Client applications also use the modernized data tier.

### Components

This architecture uses the following components.

#### Data storage

This architecture describes how to migrate data to scalable, more secure cloud storage and managed databases for flexible, intelligent data management in Azure.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a globally distributed [multiple-model](https://www.infoworld.com/article/2861579/the-rise-of-the-multimodel-database.html) [NoSQL](https://www.infoworld.com/article/3240644/what-is-nosql-databases-for-a-cloud-scale-future.html) database. In this architecture, Azure Cosmos DB serves as a scalable NoSQL target for modernizing nonrelational mainframe databases like IMS and IDMS.

- [Azure Database for MySQL](/azure/well-architected/service-guides/azure-db-mysql-cost-optimization) is a fully managed relational database service based on the community edition of the open-source [MySQL](https://www.mysql.com/products/community) database engine. In this architecture, Azure Database for MySQL provides another relational database target option for migrated mainframe data.

- [Azure Database for PostgreSQL](/azure/well-architected/service-guides/postgresql) is a fully managed relational database service based on the community edition of the open-source [PostgreSQL](https://www.postgresql.org) database engine. In this architecture, Azure Database for PostgreSQL provides an alternative target database for mainframe relational data migration.

- [SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) is part of the [Azure SQL family](/azure/azure-sql/). It's designed for the cloud and provides all the benefits of a fully managed and evergreen platform as a service (PaaS). SQL Database also provides AI-powered automated features that optimize performance and durability. Serverless compute and [Hyperscale storage options](/azure/azure-sql/database/service-tier-hyperscale) automatically scale resources on demand. In this architecture, SQL Database serves as a target database for migrated relational data from mainframe Db2 systems.

- [Azure SQL Managed Instance](/azure/well-architected/service-guides/azure-sql-managed-instance/reliability) is a cloud database service that provides all the benefits of a fully managed and evergreen PaaS. SQL Managed Instance has almost complete compatibility with the latest SQL Server Enterprise edition database engine. It also provides a native virtual network implementation that addresses common security concerns. In this architecture, SQL Managed Instance serves as a target for mainframe data that requires SQL Server compatibility and enterprise features.

- [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) is a storage repository that holds large amounts of data in its native, raw format. Data lake stores are optimized for scaling to terabytes and petabytes of data. The data typically comes from multiple heterogeneous sources. It can be structured, semi-structured, or unstructured. In this architecture, Data Lake Storage provides scalable storage for converted mainframe file system data and serves as a staging area for data transformation.

- [Microsoft Fabric Lakehouse](/fabric/data-engineering/lakehouse-overview) is a data architecture platform for storing, managing, and analyzing structured and unstructured data in a single location. In this architecture, Microsoft Fabric Lakehouse serves as a unified analytics platform for both raw mainframe data and processed datasets.

- [SQL database in Microsoft Fabric](/fabric/fundamentals/microsoft-fabric-overview) is a developer-friendly transactional database that's based on SQL Database. You can use it to create your operational database in Fabric. A SQL database in Fabric uses the same SQL database engine as SQL Database. In this architecture, SQL database in Microsoft Fabric provides a modern transactional database option for migrated mainframe operational data.

#### Compute

- [Azure Data Factory](/azure/data-factory/introduction) is Microsoft's cloud-based data integration service that integrates data across different network environments by using an [integration runtime (IR)](/azure/data-factory/concepts-integration-runtime), which is a compute infrastructure. Azure Data Factory copies data between cloud data stores and data stores in on-premises networks by using [self-hosted IRs](/azure/data-factory/concepts-integration-runtime#self-hosted-integration-runtime). In this architecture, Azure Data Factory orchestrates the entire data migration process from mainframe sources to Azure targets.

- The [on-premises data gateway](/data-integration/gateway/service-gateway-onprem) is a locally installed Windows client application that serves as a bridge between your local on-premises data sources and services in the Microsoft Cloud. In this architecture, the on-premises data gateway establishes secure connectivity between mainframe systems and Azure services.

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is an infrastructure as a service (IaaS) offering that provides on-demand, scalable computing resources. An Azure virtual machine (VM) provides the flexibility of virtualization but eliminates the maintenance demands of physical hardware. Azure VMs provide a choice of operating systems, including Windows and Linux. In this architecture, Azure Virtual Machines host migration tools like SQL Server Migration Assistant for Db2 and custom conversion applications.

#### Data integrators

This architecture outlines various Azure-native migration tools that you use depending on the mainframe source data and the target database.

- [Azure Data Factory](/azure/data-factory/introduction) is a hybrid data integration service. Azure Data Factory migrates data from Db2 sources to Azure database targets by using native connectors. In this architecture, Azure Data Factory serves as the primary data integration service for orchestrating mainframe data migration workflows.

- [AzCopy](/azure/storage/common/storage-use-azcopy-v10) is a command-line utility that moves blobs or files into and out of storage accounts. In this architecture, AzCopy transfers large volumes of mainframe file system data to Azure Storage during the migration process.

- [SQL Server Integration Services](/sql/integration-services/sql-server-integration-services) is a platform for creating enterprise-level data integration and transformation solutions. In this architecture, you use it to orchestrate data transformation tasks during mainframe migration, such as:

   - Copying or downloading files.
   - Loading data warehouses.
   - Cleansing and mining data.
   - Managing SQL Server objects and data.


- [Host Integration Server](/host-integration-server/what-is-his) technologies and tools can integrate existing IBM host systems, programs, messages, and data with Azure applications. The host file client component provides flexibility for data that's converted from EBCDIC to ASCII. For example, you can generate data in JSON or XML format from the data that's converted. In this architecture, Host Integration Server converts EBCDIC-encoded mainframe data to ASCII format for Azure consumption.

- [Microsoft Fabric](/fabric/fundamentals/microsoft-fabric-overview) is an enterprise-ready, end-to-end analytics platform. It unifies data movement, data processing, ingestion, transformation, real-time event routing, and report building. It supports these capabilities by using the following integrated services:

   - Fabric Data Engineer
   - Fabric Data Factory
   - Fabric Data Science
   - Fabric Real-Time Intelligence
   - Fabric Data Warehouse
   - Fabric Databases

In this architecture, Fabric provides a comprehensive analytics platform for end-to-end mainframe data modernization and business intelligence.

#### Other tools

- [SQL Server Migration Assistant for Db2](/sql/ssma/db2/sql-server-migration-assistant-for-db2-db2tosql) automates migration from Db2 to Microsoft database services. When this tool runs on a VM, it converts Db2 database objects into SQL Server database objects and creates those objects in SQL Server. In this architecture, SQL Server Migration Assistant for Db2 automates the conversion of mainframe Db2 database schemas and objects to Azure database targets.

- [Data Provider for Host Files](/host-integration-server/core/data-for-host-files) is a component of [Host Integration Server](/host-integration-server/what-is-his) that uses offline, SNA, or TCP/IP connections.

   - With offline connections, Data Provider reads and writes records in a local binary file.
   - With SNA and TCP/IP connections, Data Provider reads and writes records stored in remote z/OS (IBM Z series mainframe) datasets or remote i5/OS (IBM AS/400 and iSeries systems) physical files. Only i5/OS systems use TCP/IP.

   In this architecture, Data Provider for Host Files enables connectivity and data access between mainframe file systems and Azure applications.

- [Azure services](https://azurecharts.com/overview) provide environments, tools, and processes for developing and scaling new applications in the public cloud. In this architecture, Azure services provide the target cloud platform for modernized mainframe applications and data analytics workloads.

## Scenario details

Modern data storage solutions like the Azure data platform provide better scalability and performance than mainframe and midrange systems. By modernizing your systems, you can take advantage of these benefits. However, updating technology, infrastructure, and practices is complex. The process involves an exhaustive investigation of business and engineering activities. Data management is one consideration when you modernize your systems. You also need to look at data visualization and integration.

Successful modernizations use a [data-first strategy](https://www.enterpriseappstoday.com/data-management/5-reasons-a-data-first-strategy-works.html). When you use this approach, you focus on the data rather than the new system. Data management is no longer just an item on the modernization checklist. Instead, the data is the centerpiece. Coordinated, quality-oriented data solutions replace fragmented, poorly governed ones.

This solution uses Azure data platform components in a data-first approach. Specifically, the solution involves:

- **Object conversion.** Convert object definitions from the source data store to corresponding objects in the target data store.

- **Data ingestion.** Connect to the source data store and extract data.

- **Data transformation.** Transform extracted data into appropriate target data store structures.

- **Data storage.** Load data from the source data store to the target data store, both initially and continually.
 
### Potential use cases

Organizations that use mainframe and midrange systems can benefit from this solution, especially when they want to:

- Modernize mission-critical workloads.

- Acquire business intelligence to improve operations and gain a competitive advantage.

- Remove the high costs and rigidity that are associated with mainframe and midrange data stores.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/). 

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Be aware of the differences between on-premises client identities and client identities in Azure. You need to compensate for any differences.

- Use [managed identities](/entra/identity/managed-identities-azure-resources/overview) for component-to-component data flows.

- When you use Data Provider for Host Files to convert data, follow the recommendations in [Data Providers for Host Files security and protection](/host-integration-server/core/data-providers-for-host-files-security-and-protection).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- SQL Server Migration Assistant is a free, supported tool that simplifies database migration from Db2 to SQL Server, SQL Database, and SQL Managed Instance. SQL Server Migration Assistant automates all aspects of migration, including migration assessment analysis, schema and SQL statement conversion, and data migration.

- The Microsoft Fabric Lakehouse-based solution is built on open-source technologies (Delta Lake, Apache Spark). This approach eliminates the financial burden of licensing conversion tools and provides a unified SaaS experience for analytics.

- Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the cost of implementing this solution.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- The key pillars of Performance Efficiency are performance management, capacity planning, [scalability](https://azure.microsoft.com/product-categories/databases/), and choosing an appropriate performance pattern.

- You can [scale out the self-hosted IR](/azure/data-factory/concepts-integration-runtime#self-hosted-ir-compute-resource-and-scaling) by associating the logical instance with multiple on-premises machines in active-active mode.

- Use SQL Database to dynamically scale your databases. The Serverless tier can automatically scale the compute resources. Elastic pools allow databases to share resources in a pool and can only be scaled manually.

When you use the Data Provider for Host Files client to convert data, [turn on connection pooling](/host-integration-server/core/data-for-host-files#configuringForPerformance) to reduce the connection startup time. When you use Azure Data Factory to extract data, [tune the performance of the copy activity](/azure/data-factory/copy-activity-performance#performance-tuning-steps).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Ashish Khandelwal](https://www.linkedin.com/in/ashish-khandelwal-839a851a3) | Principal Engineering Architect Manager

Other contributors:

- [Nithish Aruldoss](https://www.linkedin.com/in/nithish-aruldoss-b4035b2b) | Engineering Architect
- [Rodrigo Rodríguez](https://www.linkedin.com/in/rod2k10/) | Senior Cloud Solution Architect, AI & Quantum

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review the [Azure Database Migration Guides](/data-migration). Contact [Azure Data Engineering - Mainframe & Midrange Modernization](mailto:datasqlninja@microsoft.com) for more information.

See the following articles:

- [IBM workloads on Azure](/azure/virtual-machines/workloads/mainframe-rehosting/ibm/get-started)
- [Mainframe rehosting on Azure VMs](/azure/virtual-machines/workloads/mainframe-rehosting/overview)
- [Mainframe workloads supported on Azure](/azure/virtual-machines/workloads/mainframe-rehosting/partner-workloads)
- [Move mainframe compute to Azure](/azure/virtual-machines/workloads/mainframe-rehosting/concepts/mainframe-compute-azure)

## Related resources

- [Analytics end to end with Azure Synapse Analytics](../../example-scenario/dataplate2e/data-platform-end-to-end.yml)
