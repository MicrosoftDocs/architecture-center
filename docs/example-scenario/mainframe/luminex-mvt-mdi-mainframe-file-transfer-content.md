This article presents a solution for using Luminex products to transfer mainframe data to and from Azure to meet backup, archival, and other business needs. Key components in the solution include Luminex MDI Cloud Data Sharing and MVT CloudTAPE.

### Dataflow

1. On a mainframe, secondary storage devices store data that's frequently and infrequently accessed. These devices include direct-access storage devices (DASDs) and sequential-access storage devices (SASDs).

1. DASDs are mounted on the mainframe. These devices are used for immediate data location and retrieval.

1. A tape is a type of SASD that's attached to the mainframe as external storage. Mainframes use virtual tapes (VTL) and physical tapes.

1. The Luminex MDI platform is used to send information that can be stored on files to Azure. Examples include System Management Facilities (SMF) data, virtual storage access method (VSAM) files, sequential files, and generation data groups (GDGs).

1. Luminex MVT CloudTape provides tape archival and backup.

1. MDI and MVT use FICON-based CGX controller devices to connect directly to the mainframe.

1. The mainframe data is transferred to Azure through a private, secure Azure ExpressRoute connection.

1. Luminex MDI zKonnect and other services stream the file data for big data analysis on Azure. For instance, system data like mainframe logs and SMF data is streamed to Azure Event Hubs. Azure services ingest the data and then process, transform, and project it.

1. Luminex MDI uses Luminex CGX devices to transfer file data to Azure:
   - The transfer process can use job control language (JCL) statements that Luminex provides. These statements specify information about input files, the Azure destination, keys and security information, data transformation, and cloud file formats. Organizations that use the Luminex procedure for data transfer can use their own JCL statements.
   - Alternatively, the process can be monitored from the MDI UI. The operations team can also use a combination of the scheduler, the mainframe and the MDI UI for monitoring and troubleshooting. The MDI UI provides information like the job name, the job ID, the user or group, the start time, and the elapsed time.
   - MDI retry mechanisms engage when the file transfer doesn't initially succeed.
   - If requested, the files are cached in local storage before the transfer. After the transfer finishes, the local storage is removed.

1. Luminex MVT CloudTape sends mainframe tape data to Azure data stores like Azure Blob, Azure Files, ADLS. The data can be structured and unstructured. The transfer doesn't use JCL statements. Instead, MVT Cloud Tape moves or replicates mainframe tapes in IBM 3490 or 3590 format that CGX controllers emulate.

1. Azure services are used for data processing, storage, analytics, and visualization.

### Components

- [Azure ExpressRoute](https://azure.microsoft.com/en-us/products/expressroute) extends on-premises networks into the Microsoft cloud. By using a connectivity provider, ExpressRoute establishes private connections between on-premises data and Microsoft cloud services.

- [Azure Files](https://azure.microsoft.com/products/storage/files) is a service that's part of [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/storage-introduction). Azure Files offers fully managed file shares in the cloud. Azure file shares are accessible via the industry standard Server Message Block (SMB) protocol. This solution uses Luminex MDI and MVT to transfer mainframe files to Azure Files.

- [Blob Storage](https://azure.microsoft.com/products/storage/blobs) is a service that's part of Storage. Blob Storage provides optimized cloud object storage for massive amounts of unstructured data. In this solution, Blob Storage provides a solution for the hot and cold archival of the mainframe data.

- In this solution, Luminex products can transfer mainframe data to several Azure databases:

  - [Azure SQL](https://azure.microsoft.com/services/azure-sql) is a family of Azure databases that are powered by the SQL Server engine.
  - [Azure SQL Database](https://azure.microsoft.com/services/sql-database) is a fully managed PaaS database engine that's part of the Azure SQL family. With AI-powered, automated features, SQL Database handles database management functions like upgrading, patching, backups, and monitoring.
  - [Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql) is a fully managed relational database service that's based on the community edition of the open-source PostgreSQL database engine.
  - [Azure Database for MySQL](https://azure.microsoft.com/products/mysql) is a fully managed relational database service that's based on the community edition of the open-source MySQL database engine.

- [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs) is a fully managed big data streaming platform. In this solution, Luminex zKonnect streams mainframe data to Event Hubs in near real time. Event Hubs provides an endpoint that's compatible with Apache Kafka producer and consumer APIs. Most existing Apache Kafka client applications use these APIs as an alternative to running their own Apache Kafka clusters.

- [Power BI](https://powerbi.microsoft.com/) is a collection of software services and apps that display analytics information. This solution takes mainframe data that comes from various sources and has varying structures. It then uses Power BI to turn the data into coherent, visually immersive, and interactive insights.

- [Azure Data Lake Storage](https://azure.microsoft.com/en-us/products/storage/data-lake-storage/) provides a way to perform big data analytics with low-cost, tiered storage and high throughput.