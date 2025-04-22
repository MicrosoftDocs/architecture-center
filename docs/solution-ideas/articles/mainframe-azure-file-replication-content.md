[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

When you migrate an on-premises mainframe or midrange application to Azure, transferring the data is a primary consideration. Several modernization scenarios require replicating files to Azure quickly or maintaining synchronization between on-premises files and Azure files.

This article describes several processes for transferring files to Azure, converting and transforming file data, and storing the data on-premises and in Azure. 

## Architecture

The following diagram shows some of the options for replicating and syncing on-premises files to Azure:

:::image type="content" border="false" source="../media/mainframe-azure-file-replication-updated.svg" alt-text="Diagram showing the three steps of migrating on-premises files to Azure: transferring, conversion and transformation, and storing in persistent storage." lightbox="../media/mainframe-azure-file-replication-updated.svg":::

*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/mainframe-azure-file-replication-updated.vsdx) of this architecture.*

### Dataflow

1. Transfer files to Azure:

   - The easiest way to transfer files on-premises or to Azure is by using [File Transfer Protocol (FTP)](https://en.wikipedia.org/wiki/File_Transfer_Protocol). You can host an FTP server on an Azure virtual machine (VM). A simple FTP job control language (JCL) sends files to Azure in binary format, which is essential to preserving mainframe and midrange computation and binary data types. You can store transmitted files in on-premises disks, Azure VM file storage, or Azure Blob Storage.
     
   - You can also upload on-premises files to Blob Storage by using tools like [AzCopy](/azure/storage/common/storage-use-azcopy-v10).
     
   - The Azure Data Factory FTP/SFTP connector can also be used to transfer data from the mainframe system to Blob Storage. This method requires an intermediate VM on which a self-hosted integration runtime (SHIR) is installed.
     
   - You can also find third-party tools in [Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace) to transfer files from mainframes to Azure.

1. Orchestrate, convert, and transform data:

   - Azure can't read IBM Extended Binary Coded Decimal Interchange Code (EBCDIC) code page files in Azure VM disks or Blob Storage. To make these files compatible with Azure, Host Integration Server (HIS) converts them from EBCDIC to American Standard Code for Information Interchange (ASCII) format.

     Copybooks define the data structure of COBOL, PL/I, and assembly language files. HIS converts these files to ASCII based on the copybook layouts.

   - Mainframe File Data conversion can also be accomplished by using Azure Logic Apps connector for IBM host files.

   - Before transferring data to Azure data stores, you might need to transform the data or use it for analytics. Data Factory can manage these extract-transform-load (ETL) and extract-load-transform (ELT) activities and store the data directly in Azure Data Lake Storage.

   - For big data integrations, Azure Databricks and Azure Synapse Analytics can perform all transformation activities fast and effectively by using the Apache Spark engine to perform in-memory computations.

1. Store data:

   You can store transferred data in one of several available persistent Azure storage modes, depending on your requirements.

   - If there's no need for analytics, Azure Data Factory can store data directly in a wide range of storage options, such as Data Lake Storage and Blob Storage.

   - [Azure hosts various databases](/azure/architecture/guide/technology-choices/data-options), which address different needs:

     - Relational databases include the SQL Server family, and open-source databases like PostgreSQL and MySQL.
     - Non-relational databases include Azure Cosmos DB, a fast, multi-model, globally distributed NoSQL database.

1. Review analytics and business intelligence:

   [Microsoft Fabric](/fabric/get-started/microsoft-fabric-overview) is an all-in-one analytics solution that your organization can use to study data movement, experiment with data sciences, and review real-time analytics and business intelligence. It offers a comprehensive suite of features, including a data lake, data engineering, and data integration.

### Components

This architecture uses the following components.

#### Networking

An [on-premises data gateway](/data-integration/gateway/service-gateway-onprem) is bridge software in this architeture that connects on-premises Mainframe data to cloud services. You can install the gateway [on a dedicated on-premises VM](/azure/logic-apps).

#### Data integration and transformation

This architecture outlines various Azure-native migration tools that you use depending on the mainframe source data and the target database.

- [Data Provider for Host Files](/host-integration-server/core/data-for-host-files) is a component of [HIS](/host-integration-server/what-is-his) that converts EBCDIC code page files to ASCII. The  provider can read and write records offline in a local binary file, or use Systems Network Architecture (SNA) or Transmission Control Protocol/Internet Protocol (TCP/IP) to read and write records in remote IBM z/OS mainframe datasets or i5/OS physical files. HIS connectors are available for [BizTalk](/host-integration-server/core/biztalk-adapter-for-host-files-configuration1) and [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps).

- [Azure Data Factory](https://azure.microsoft.com/services/data-factory) is a hybrid data integration service you can use to create, schedule, and orchestrate ETL and ELT workflows. In this architecture it is used to FTP Mainframe file to Azure Blob storage.

- [Azure Databricks](/azure/databricks/scenarios/what-is-azure-databricks) is an Apache Spark-based analytics platform optimized for Azure. You can use Databricks to correlate incoming data, and enrich it with other data stored in Databricks.
  
- [Azure Synapse Analytics](https://azure.microsoft.com/en-us/products/synapse-analytics/) is a fast and flexible cloud data warehouse with a massively parallel processing (MPP) architecture that you can use to scale, compute, and store data elastically and independently. It can be used for Mainframe data transformation to load into Azure Database.

- [Azure Logic Apps](/azure/logic-apps/logic-apps-overview): Azure Logic Apps offers a native Host File connector which interacts with Mainframe systems to read, parse, and generate host file content.

#### Databases

This architecture outlines the process of migrating Mainframe file data to cloud storage and managed databases in Azure. It involves moving data to various Azure databases and converting Mainframe file metadata to match the target schema in Azure.

- [Azure SQL Database](https://azure.microsoft.com/services/sql-database) is a scalable relational cloud database service. Azure SQL Database is evergreen and always up to date, with AI-powered and automated features that optimize performance and durability. Serverless compute and hyperscale storage options automatically scale resources on demand. With [Azure Hybrid Benefit](https://azure.microsoft.com/pricing/hybrid-benefit), you can use your existing on-premises SQL Server licenses on the cloud with no extra cost.

- [Azure SQL Managed Instance](https://azure.microsoft.com/services/azure-sql/sql-managed-instance) combines the broadest SQL Server database engine compatibility with all the benefits of a fully managed and evergreen platform as a service (PaaS). With SQL Managed Instance, you can modernize your existing apps at scale with familiar tools, skills, and resources.

- [SQL Server on Azure Virtual Machines](https://azure.microsoft.com/en-in/services/virtual-machines/sql-server) lifts and shifts your SQL Server workloads to the cloud to combine the flexibility and hybrid connectivity of Azure with SQL Server performance, security, and analytics. You can access the latest SQL Server updates and releases with 100% code compatibility.

- [Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql) is a fully managed relational database service based on the community edition of the open-source PostgreSQL database engine.

- [Azure Database for MySQL](https://azure.microsoft.com/en-us/products/mysql/) is a fully managed relational database service based on the community edition of the open-source MySQL database engine.

- [Azure Cosmos DB](https://azure.microsoft.com/en-us/products/cosmos-db/) is a fully managed, multi-model NoSQL database service for building and modernizing scalable, high-performance applications. Azure Cosmos DB scales throughput and storage elastically and independently across geographic regions and guarantees single-digit-millisecond latencies at 99th percentile availability anywhere in the world.

#### Other data stores

- [Blob Storage](https://azure.microsoft.com/services/storage/blobs) stores large amounts of unstructured data, such as text or binary data, that you can access from anywhere via HTTP or HTTPS. You can use Blob Storage to expose data publicly or to store application data privately.

- [Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) is a storage repository that holds a large amount of data in native, raw format. Data Lake Storage provides scaling for big data analytics workloads with terabytes and petabytes of data. The data typically comes from multiple heterogeneous sources, and might be structured, semi-structured, or unstructured.

## Scenario Details

Converting Mainframe files from EBCDIC encoded format to ASCII format is necessary for migrating data from mainframe systems to Azure cloud storage and databases. Mainframe applications generate and handle large amounts of data daily, which must be accurately converted for use in other platforms. 

As organizations transition mainframe file system data it involves transforming the file metadata to cloud native schematics, and a migration strategy including effective file conversion techniques. 

## Potential use cases

On-premises file replication and synchronization use cases include:

- Downstream or upstream dependencies, for example if applications that run on a mainframe and applications that run on Azure need to exchange data via files.
  
- Parallel testing of rehosted or re-engineered applications on Azure with on-premises applications.
  
- Tightly coupled on-premises applications on systems that can't immediately be remediated or modernized.
  
## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Ashish Khandelwal](https://www.linkedin.com/in/ashish-khandelwal-839a851a3/) | Principal Engineering Architecture Manager
- [Nithish Aruldoss](https://www.linkedin.com/in/nithish-aruldoss-b4035b2b) | Engineering Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- For more information, contact [Microsoft SQL Data Engineering team](mailto:datasqlninja@microsoft.com).
- [Azure database migration guides](https://datamigration.microsoft.com)

## Related resources

- [Replicate and sync mainframe data in Azure](../../reference-architectures/migration/sync-mainframe-data-with-azure.yml)
- [Modernize mainframe and midrange data](../../example-scenario/mainframe/modernize-mainframe-data-to-azure.yml)
- [Migrate IBM mainframe applications to Azure with TmaxSoft OpenFrame](./migrate-mainframe-apps-with-tmaxsoft-openframe.yml)
- [Unisys mainframe migration with Avanade AMT](../../reference-architectures/migration/unisys-mainframe-migration.yml)
