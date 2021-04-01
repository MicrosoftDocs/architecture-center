When modernizing on-premises mainframe and midrange applications, moving data from on-premises to Azure forms the backbone for application migration. During modernization, several scenarios require replicating files to Azure in a timely manner, or maintaining a sync between on-premises and Azure files. This article discusses several different processes for moving files to Azure, performing conversions and transformations, and storing files on-premises and in Azure. The article highlights a wide range of Azure services to demonstrate the possibilities.

## Potential use cases

On-premises file replication and sync use cases include:

- Downstream or upstream dependency, if applications running on the mainframe and applications running on Azure need to exchange data via files.
- Parallel testing of rehosted or re-engineered applications on Azure with on-premises applications.
- Tightly-coupled on-premises applications on systems that can't be immediately remediated or modernized.

## Architecture

The following diagram shows some of the options for migrating on-premises files to Azure:

![Diagram showing the three steps of migrating on-premises files to Azure: moving, conversion and transformation, and storing in persistent storage.](../media/mainframe-azure-file-replication.svg)

Replicating and syncing on-premises files to Azure storage consists of the following processes:

1. Move files to Azure:
   
   - The easiest way to move files on-premises or to Azure is by using [File Transfer Protocol (FTP)](https://en.wikipedia.org/wiki/File_Transfer_Protocol). You can host an FTP server on an Azure virtual machine (VM). A simple FTP job control language (JCL) sends files to Azure in binary format, which is essential to conserving mainframe and midrange computation and binary data types. You can store transmitted files in on-premises disks, Azure VM file storage, or Azure Blob storage.
   
   - An on-premises data gateway and firewall allow secure connections to cloud services for on-premises data.

   - You can also upload on-premises files to Blob storage by using tools like [AzCopy](/azure/storage/common/storage-use-azcopy-v10).
   
   - Azure Data Factory also hosts a variety of data source connectors for migrating file data into Azure.
   
   - There are also third-party solutions that can help move files from mainframes to Azure. You can find some of them in the [Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace/).
   
2. Orchestrate, convert, and transform data:
   
   - Azure can't read IBM Extended Binary Coded Decimal Interchange Code (EBCDIC) code page files in Azure VM disks or Azure Blobs. Host Integration server (HIS) can convert the files from EBCDIC to American Standard Code for Information Interchange (ASCII) format to make them compatible with the Azure character set. Copybooks define the data structure of COBOL, PL/I, and assembly language files. HIS converts these files to ASCII based on the copybook layouts.
   
   - Before moving data to Azure data stores, you might need to transform the data or use it for analytics. An ingest layer in Azure Data Lake can do these *extract-transform-load (ETL)* activities. In this case, Azure Data Factory can store the data directly in Azure Data Lake.
   
   - For big data integrations, Azure Databricks can perform all transformation activities fast and effectively by using the Apache Spark engine to do in-memory computations.

3. Store data:
   
   You can store moved data in one of several available persistent Azure storage modes, depending on your requirements.

   - If there's no need for analytics, you can store data directly in Azure Data Factory.
   
   - Azure hosts a variety of databases, which address different needs:
     
     - Relational databases include the SQL Server family, and open-source databases like PostgreSQL, MariaDB, and MySQL.
     - Non-relational databases include Azure Cosmos DB, a fast, multi-model, NoSQL database.

### Components

Various file moving, integration, and storage scenarios use different components. See the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for Azure resources.

#### Networking

- [On-premises data gateway](/data-integration/gateway/service-gateway-onprem) is bridge software that connects on-premises data to cloud services. The gateway typically [installs on a dedicated on-premises VM](/azure/logic-apps/).

#### Data integration and transformation

- [Data Provider for Host Files](/host-integration-server/core/data-for-host-files) is the component of [HIS](/host-integration-server/what-is-his) that converts EBCDIC code page files to ASCII. The  provider can read and write records offline in a local binary file, or use Systems Network Architecture (SNA) or Transmission Control Protocol/Internet Protocol (TCP/IP) to read and write records in remote IBM z/OS mainframe data sets or i5/OS physical files. HIS connectors are available for [BizTalk](/host-integration-server/core/biztalk-adapter-for-host-files-configuration1) and [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps/).

- [Azure Data Factory](https://azure.microsoft.com/services/data-factory/) is a hybrid data integration service that helps you create, schedule, and orchestrate ETL and *extract-load-transform* (ELT) workflows.

- [Azure Databricks](/azure/azure-databricks) is an Apache Spark-based analytics platform optimized for the Azure platform. You can use Databricks to correlate data, and enrich the data with other data stored in Databricks.

#### Databases

- [Azure SQL Database](https://azure.microsoft.com/services/sql-database/) is a scalable relational cloud database service. Part of the Azure SQL family, Azure SQL Database is evergreen and always up to date, with AI-powered and automated features that optimize performance and durability. Serverless compute and hyperscale storage options automatically scale resources on demand.

- [Azure SQL Managed Instance](https://azure.microsoft.com/services/azure-sql/sql-managed-instance/) combines the broadest SQL Server database engine compatibility with all the benefits of a fully managed and evergreen platform as a service. With SQL Managed Instance, you can modernize your existing apps at scale with familiar tools, skills, and resources.

- [Azure SQL on VM](https://azure.microsoft.com/en-in/services/virtual-machines/sql-server/) lifts and shifts your SQL Server workloads to the cloud to combine the flexibility and hybrid connectivity of Azure with SQL Server performance, security, and analytics. You can access the latest SQL Server updates and releases with 100 percent code compatibility. With [Azure Hybrid Benefit](https://azure.microsoft.com/pricing/hybrid-benefit/), you can use your existing on-premises SQL Server licenses on the cloud with no additional cost.

- [Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql/) is a fully managed relational database service based on the community edition of the open-source PostgreSQL database engine.

- [Azure Database for MySQL](/azure/mysql/overview) is a fully managed relational database service based on the community edition of the open-source MySQL database engine.

- [Azure Database for MariaDB](https://azure.microsoft.com/services/mariadb/) combines MariaDB community edition with the benefits of a fully managed service provider.

- [Azure Cosmos DB](/azure/cosmos-db/introduction) is a fully managed NoSQL database service for building and modernizing scalable, high-performance applications. Azure Cosmos DB is a globally distributed, multi-model database that scales your throughput and storage elastically and independently across geographic regions. Azure Cosmos DB guarantees single-digit-millisecond latencies at 99th percentile availability anywhere in the world.

#### Other data stores

- [Azure Blob](https://azure.microsoft.com/services/storage/blobs/) stores large amounts of unstructured data, such as text or binary data, that you can access from anywhere via HTTP or HTTPS. You can use Blob storage to expose data publicly, or to store application data privately.

- [Azure Data Lake](https://azure.microsoft.com/services/storage/data-lake-storage/) is a storage repository that holds a large amount of data in native, raw format. Azure Data Lake stores are optimized for scaling to terabytes and petabytes of data. The data typically comes from multiple heterogeneous sources, and may be structured, semi-structured, or unstructured.

## Next steps

- For more information, contact Azure Data Engineering On-premises Modernization at datasqlninja@microsoft.com.
- Read the [Azure Database Migration Guides](https://datamigration.microsoft.com/).

## Related resources

- [Replicate and sync mainframe data in Azure](/azure/architecture/reference-architectures/migration/sync-mainframe-data-with-azure)
- [Modernize mainframe and midrange data](/azure/architecture/reference-architectures/migration/modernize-mainframe-data-to-azure)
- [Migrate IBM mainframe applications to Azure with TmaxSoft OpenFrame](/azure/architecture/solution-ideas/articles/migrate-mainframe-apps-with-tmaxsoft-openframe)
- [Unisys mainframe migration with Asysco](/azure/architecture/reference-architectures/migration/unisys-mainframe-migration)

