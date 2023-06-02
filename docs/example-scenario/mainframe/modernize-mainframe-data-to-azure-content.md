This article describes an end-to-end modernization plan for mainframe and midrange data sources.

*Apache®, [Spark](https://spark.apache.org), and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image source="./media/modernize-mainframe-data.png" alt-text="Architecture diagram that shows how to modernize mainframe and midrange systems by migrating data to Azure." border="false" lightbox="./media/modernize-mainframe-data.png":::

*Download a [Visio file](https://arch-center.azureedge.net/modernize-mainframe-data.vsdx) of this architecture.*

### Dataflow

The following dataflow outlines a process for modernizing a mainframe data tier. It corresponds to the preceding diagram.

1. The [on-premises data gateway](/data-integration/gateway) provides enhanced-security data transfer between mainframe on-premises data and Azure services.

1. The object conversion process extracts object definitions from source objects. The definitions are then converted into corresponding objects in the target data store.

   -	[SQL Server Migration Assistant](/sql/ssma/sql-server-migration-assistant) for Db2 migrates schemas and data from IBM Db2 databases to Azure databases.
   - Managed Data Provider for Host Files converts objects by:
       - Parsing COBOL and RPG record layouts, or *copybooks*.
       - Mapping the copybooks to C# objects that .NET applications use.
   -	Third-party tools perform automated object conversion on non-relational databases, file systems, and other data stores.

1. Data is ingested and transformed.

   a. FTP transfers mainframe and midrange file system datasets with single layouts and unpacked fields in binary format to Azure.
   
   b. Mainframe data is converted. Mainframe and midrange systems store data on DASD or tape in EBCDIC format in these types of files:
      - Indexed [VSAM](/sql/ssma/sql-server-migration-assistant) files
      -	Non-indexed [GDG](https://www.ibm.com/support/knowledgecenter/zosbasics/com.ibm.zos.zconcepts/zconcepts_175.htm) files
      - [Flat files](https://www.pcmag.com/encyclopedia/term/flat-file)

      COBOL, PL/I, and assembly language copybooks define the data structure of these files. Data Provider for Host Files converts the data from EBCDIC to ASCII format based on the copybook layout.

      An Azure Data Factory custom connector uses the Host File client component of Host Integration Server to convert mainframe datasets.

      [Host Integration Server](/host-integration-server/what-is-his) integrates existing IBM host systems, programs, messages, and data with Azure applications.

      A solution that's based on open-source software and is used in [Azure Synapse Analytics](https://azure.microsoft.com/products/synapse-analytics) converts data. 

   c. Relational database data is migrated. 

      IBM mainframe and midrange systems store data in relational databases like these:
      - [Db2 for z/OS](https://www.ibm.com/analytics/db2/zos)
      - [Db2 for Linux UNIX and Windows](https://www.ibm.com/support/knowledgecenter/en/SSEPGG_10.5.0/com.ibm.db2.luw.kc.doc/welcome.html)
      - [Db2 for IBM i](https://www.ibm.com/support/pages/db2-ibm-i)
     
      These services migrate the database data:
     - Data Factory uses a Db2 connector to extract and integrate data from the databases.
     - SQL Server Integration Services handles various data [ETL](https://www.ibm.com/cloud/learn/etl) tasks.

   d. Non-relational database data is migrated.

      IBM mainframe and midrange systems store data in non-relational databases like these:
    - [IDMS](https://www.broadcom.com/products/mainframe/databases-database-mgmt/idms), a [network model](https://web.archive.org/web/20060904190944/http:/coronet.iicm.edu/wbtmaster/allcoursescontent/netlib/ndm1.htm) database management system (DBMS)
    - [IMS](https://www.ibm.com/it-infrastructure/z/ims), a [hierarchical model](https://www.ibm.com/support/knowledgecenter/SSEPH2_14.1.0/com.ibm.ims14.doc.apg/ims_comparehierandreldbs.htm) DBMS
    - [Adabas](https://www.softwareag.com/en_corporate/platform/adabas-natural.html)
    - [Datacom](https://www.broadcom.com/products/mainframe/databases-database-mgmt/datacom)
      
    Third-party products integrate data from these databases.

1. Azure services like Data Factory and [AzCopy](/azure/storage/common/storage-ref-azcopy) load data into Azure databases and Azure data storage. You can also use third-party solutions and custom loading solutions to load data.

1. Data is moved to storage.

   Azure provides many managed data storage solutions:
   - Databases:
     - [Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview)
     - [Azure Database for PostgreSQL](/azure/postgresql/single-server/overview)
     - [Azure Cosmos DB](/azure/cosmos-db/introduction)
     - [Azure Database for MySQL](/azure/mysql/overview)
     - [Azure Database for MariaDB](/azure/mariadb)
     - [Azure SQL Managed Instance](/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview)
   - Storage:
     - [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction)
     - [Azure Blob Storage](/azure/storage/blobs/storage-blobs-overview#about-blob-storage)

1. Azure services use the modernized data tier for computing, analytics, storage, and networking.

1. Client applications also use the modernized data tier.

### Components

#### Data storage

- [SQL Database](https://azure.microsoft.com/services/sql-database) is part of the [Azure SQL family](https://azure.microsoft.com/services/azure-sql). It's built for the cloud and provides all the benefits of a fully managed and evergreen platform as a service. SQL Database also provides AI-powered automated features that optimize performance and durability. Serverless compute and [Hyperscale storage options](/azure/azure-sql/database/service-tier-hyperscale) automatically scale resources on demand.
- [Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql) is a fully managed relational database service that's based on the community edition of the open-source [PostgreSQL](https://www.postgresql.org) database engine. 
- [Azure Cosmos DB](https://azure.microsoft.com/products/cosmos-db) is a globally distributed [multimodel](https://www.infoworld.com/article/2861579/the-rise-of-the-multimodel-database.html) [NoSQL](https://www.infoworld.com/article/3240644/what-is-nosql-databases-for-a-cloud-scale-future.html) database.
- [Azure Database for MySQL](https://azure.microsoft.com/products/mysql) is a fully managed relational database service that's based on the community edition of the open-source [MySQL](https://www.mysql.com/products/community) database engine.
- [Azure Database for MariaDB](https://azure.microsoft.com/products/mariadb) is a cloud-based relational database service. It's based on the [MariaDB](https://mariadb.org) community edition database engine.
- [SQL Managed Instance](https://azure.microsoft.com/products/azure-sql/managed-instance) is an intelligent, scalable cloud database service that offers all the benefits of a fully managed and evergreen platform as a service. SQL Managed Instance has near-100% compatibility with the latest SQL Server Enterprise edition database engine. It also provides a native virtual network implementation that addresses common security concerns.
- [Azure Data Lake Storage](https://azure.microsoft.com/products/storage/data-lake-storage) is a storage repository that holds large amounts of data in its native, raw format. Data lake stores are optimized for scaling to terabytes and petabytes of data. The data typically comes from multiple heterogeneous sources. It can be structured, semi-structured, or unstructured.

#### Networking

- An [on-premises data gateway](/data-integration/gateway/service-gateway-onprem) provides enhanced-security data transfer between mainframe on-premises data and Azure services. Typically, [you install the gateway on a dedicated on-premises VM](/data-integration/gateway/service-gateway-install). 
- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) provides on-demand, scalable computing resources. An Azure virtual machine (VM) provides the flexibility of virtualization but eliminates the maintenance demands of physical hardware. Azure VMs offer a choice of operating systems, including Windows and Linux.

#### Data integrators

- [Azure Data Factory](https://azure.microsoft.com/services/data-factory) is a hybrid data integration service. In this solution, an Azure Data Factory custom connector uses the Host File client component of Host Integration Server to convert mainframe datasets. With minimal setup, you can use a custom connector to convert your mainframe dataset just as you'd use any other Azure Data Factory connector.
- [AzCopy](/azure/storage/common/storage-use-azcopy-v10) is a command-line utility that moves blobs or files into and out of storage accounts.
- [SQL Server Integration Services](/sql/integration-services/sql-server-integration-services) is a platform for creating enterprise-level data integration and transformation solutions. You can use it to solve complex business problems by:
   - Copying or downloading files.
   - Loading data warehouses.
   - Cleansing and mining data.
   - Managing SQL Server objects and data.
- [Host Integration Server](/host-integration-server/what-is-his) technologies and tools enable you to integrate existing IBM host systems, programs, messages, and data with Azure applications. The Host File client component provides flexibility for data that's converted from EBCDIC to ASCII. For example, you can generate JSON/XML from the data that's converted.
- [Azure Synapse](https://azure.microsoft.com/products/synapse-analytics) brings together data integration, enterprise data warehousing, and big data analytics. The Azure Synapse conversion solution used in this architecture is based on Apache Spark and is a good candidate for large mainframe-dataset workload conversion. It supports a wide range of mainframe data structures and targets and requires minimal coding effort.

#### Other tools

- [SQL Server Migration Assistant for Db2](/sql/ssma/db2/sql-server-migration-assistant-for-db2-db2tosql) automates migration from Db2 to Microsoft database services. When it runs on a VM, this tool converts Db2 database objects into SQL Server database objects and creates those objects in SQL Server. 
- [Data Provider for Host Files](/host-integration-server/core/data-for-host-files) is a component of [Host Integration Server](/host-integration-server/what-is-his) that uses offline, SNA, or TCP/IP connections.
   - With offline connections, Data Provider reads and writes records in a local binary file.
   - With SNA and TCP/IP connections, Data Provider reads and writes records stored in remote z/OS (IBM Z Series Mainframe) datasets or remote i5/OS (IBM AS/400 and iSeries systems) physical files. Only i5/OS systems use TCP/IP.
- [Azure services](https://azurecharts.com/overview) provide environments, tools, and processes for developing and scaling new applications in the public cloud.

## Scenario details

Modern data storage solutions like the Azure data platform provide better scalability and performance than mainframe and midrange systems. By modernizing your systems, you can take advantage of these benefits. However, updating technology, infrastructure, and practices is complex. The process involves an exhaustive investigation of business and engineering activities. Data management is one consideration when you modernize your systems. You also need to look at data visualization and integration.

Successful modernizations use a [data-first strategy](http://www.enterpriseappstoday.com/data-management/5-reasons-a-data-first-strategy-works.html). When you use this approach, you focus on the data rather than the new system. Data management is no longer just an item on the modernization checklist. Instead, the data is the centerpiece. Coordinated, quality-oriented data solutions replace fragmented, poorly governed ones.

This solution uses Azure data platform components in a data-first approach. Specifically, the solution involves:

- **Object conversion.** Converting object definitions from the source data store to corresponding objects in the target data store.
- **Data ingestion.** Connecting to the source data store and extracting data.
- **Data transformation.** Transforming extracted data into appropriate target data store structures.
- **Data storage.** Loading data from the source data store to the target data store, both initially and continually.
 
### Potential use cases

Organizations that use mainframe and midrange systems can benefit from this solution, especially when they want to achieve these goals:

- Modernize mission-critical workloads.
- Acquire business intelligence to improve operations and gain a competitive advantage.
- Remove the high costs and rigidity that are associated with mainframe and midrange data stores.

## Recommendations

- When you use the Data Provider for Host Files client to convert data, [turn on connection pooling](/host-integration-server/core/data-for-host-files#configuringForPerformance) to reduce connection startup time.
- When you use Data Factory to extract data, [tune the performance of the copy activity](/azure/data-factory/copy-activity-performance#performance-tuning-steps).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- The on-premises data gateway provides a level of data protection during transfers from on-premises to Azure systems.
- When you use Data Provider for Host Files to convert data, follow the recommendations in [Data Providers for Host Files security and protection](/host-integration-server/core/data-providers-for-host-files-security-and-protection).

### Cost optimization

Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- SQL Server Migration Assistant is a free, supported tool that simplifies database migration from Db2 to SQL Server, SQL Database, and SQL Managed Instance. SQL Server Migration Assistant automates all aspects of migration, including migration assessment analysis, schema and SQL statement conversion, and data migration.
- The Azure Synapse Spark-based solution is built from open-source libraries. It eliminates the financial burden of licensing conversion tools.
- Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the cost of implementing this solution.

### Operational excellence 

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

When you use an on-premises application gateway, be aware of the [limits on read and write operations](/data-integration/gateway/service-gateway-onprem#considerations).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author: 

- [Ashish Khandelwal]( https://www.linkedin.com/in/ashish-khandelwal-839a851a3) | Principal Engineering Architect Manager

Other contributors: 

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
- [Nithish Aruldoss](https://www.linkedin.com/in/nithish-aruldoss-b4035b2b) | Engineering Architect 

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review the [Azure Database Migration Guides](/data-migration). Contact [Azure Data Engineering - Mainframe & Midrange Modernization](mailto:datasqlninja@microsoft.com) for more information.

See these articles: 
- [IBM workloads on Azure](/azure/virtual-machines/workloads/mainframe-rehosting/ibm/get-started)
- [Mainframe rehosting on Azure virtual machines](/azure/virtual-machines/workloads/mainframe-rehosting/overview)
- [Mainframe workloads supported on Azure](/azure/virtual-machines/workloads/mainframe-rehosting/partner-workloads)
- [Move mainframe compute to Azure](/azure/virtual-machines/workloads/mainframe-rehosting/concepts/mainframe-compute-azure)

## Related resources

- [Azure data architecture guide](../../data-guide/index.md)
- [Azure data platform end-to-end](../../example-scenario/dataplate2e/data-platform-end-to-end.yml)
