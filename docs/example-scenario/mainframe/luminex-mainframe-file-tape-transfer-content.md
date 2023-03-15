This article presents a solution for using Luminex products to transfer mainframe data to and from Azure to meet backup, archival, and other business needs. Key components in the solution include Luminex Mainframe Data Integration (MDI) Cloud Data Sharing and Luminex Mainframe Virtual Tape (MVT) CloudTAPE.

*Apache® and [Apache Kafka](https://kafka.apache.org/) are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="content" source="media/luminex-mainframe-file-tape-transfer-architecture.png" alt-text="Architecture diagram that shows how Luminex products migrate mainframe file and tape data to Azure." lightbox="media/luminex-mainframe-file-tape-transfer-architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/luminex-mainframe-file-tape-transfer-architecture.vsdx) of this architecture.*

### Dataflow

1. On a mainframe, secondary storage devices include direct-access storage devices (DASDs) and sequential-access storage devices (SASDs).

1. DASDs are mounted on the mainframe.

1. A tape is a type of SASD that's attached to the mainframe as external storage.

1. The MDI platform is used to send information that can be stored on files to Azure. Examples include System Management Facilities (SMF) data, virtual storage access method (VSAM) files, sequential files, and generation data groups (GDGs).

1. MVT CloudTAPE provides tape archival and backup.

1. MDI and MVT use FICON-based CGX controller devices to connect directly to the mainframe.

1. The mainframe data is transferred to Azure through a private, secure Azure ExpressRoute connection.

1. MDI zKonnect and other services stream the file data for big data analysis on Azure. For instance, system data like mainframe logs and SMF data is streamed to Azure Event Hubs. Azure services ingest the data and then process, transform, and project it.

1. MDI uses Luminex CGX devices to process, transfer, and cache file data:
   - The transfer process to Azure can use job control language (JCL) statements that Luminex provides. These statements specify information about input files, the Azure destination, keys and security information, data transformation, and cloud file formats. Organizations that use the Luminex procedure for data transfer can use their own JCL statements.
   - Alternatively, the process can be monitored from the MDI UI. The operations team can also use a combination of the scheduler, the mainframe and the MDI UI for monitoring and troubleshooting. The MDI UI provides information like the job name, the job ID, the user or group, the start time, and the elapsed time.
   - MDI retry mechanisms engage when the file transfer doesn't initially succeed.
   - If requested, the files are cached in local storage before the transfer. After the transfer finishes, the local storage is removed.

1. MVT CloudTAPE sends mainframe tape data to Azure data stores like Azure Blob, Azure Files, ADLS. The data can be structured and unstructured. The transfer doesn't use JCL statements. Instead, MVT CloudTAPE moves or replicates mainframe tapes in IBM 3490 or 3590 format that CGX controllers emulate.

1. Azure services provide data processing, storage, analytics, and visualization capabilities.

### Components

- [Azure ExpressRoute](https://azure.microsoft.com/en-us/products/expressroute) extends on-premises networks into the Microsoft cloud. By using a connectivity provider, ExpressRoute establishes private connections between on-premises data and Microsoft cloud services.

- [Azure Files](https://azure.microsoft.com/products/storage/files) is a service that's part of [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/storage-introduction). Azure Files offers fully managed file shares in the cloud. Azure file shares are accessible via the industry standard Server Message Block (SMB) protocol. This solution uses Luminex MDI and MVT to transfer mainframe files to Azure Files.

- [Blob Storage](https://azure.microsoft.com/products/storage/blobs) is a service that's part of Storage. Blob Storage provides optimized cloud object storage for massive amounts of unstructured data. In this solution, Blob Storage provides a way to archive hot and cold mainstream data.

- In this solution, Luminex products can transfer mainframe data to several Azure databases:

  - [Azure SQL](https://azure.microsoft.com/services/azure-sql) is a family of Azure databases that are powered by the SQL Server engine.
  - [Azure SQL Database](https://azure.microsoft.com/services/sql-database) is a fully managed PaaS database engine that's part of the Azure SQL family. With AI-powered, automated features, SQL Database handles database management functions like upgrading, patching, backups, and monitoring.
  - [Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql) is a fully managed relational database service that's based on the community edition of the open-source PostgreSQL database engine.
  - [Azure Database for MySQL](https://azure.microsoft.com/products/mysql) is a fully managed relational database service that's based on the community edition of the open-source MySQL database engine.

- [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs) is a fully managed big data streaming platform. In this solution, [Luminex zKonnect](https://luminexmdi.com/solutions/luminex-mdi-zkonnect/) streams mainframe data to Event Hubs in near real time. Event Hubs provides an endpoint that's compatible with Apache Kafka producer and consumer APIs. Most existing Apache Kafka client applications use these APIs as an alternative to running their own Apache Kafka clusters.

- [Power BI](https://powerbi.microsoft.com/) is a collection of software services and apps that display analytics information. This solution takes mainframe data that comes from various sources and has varying structures. It then uses Power BI to turn the data into coherent, visually immersive, and interactive insights.

- [Azure Data Lake Storage](https://azure.microsoft.com/products/storage/data-lake-storage/) provides a way to perform big data analytics with low-cost, tiered storage and high throughput.

### Alternatives

- Instead of using third-party solutions for data transfer, you can use a Microsoft solution. For information about transferring data from mainframe and midrange systems to Azure, see [Move archive data from mainframe systems to Azure](./move-archive-data-mainframes.yml). For information about specific Microsoft solutions, see the following resources:
  - [Copy files from Mainframe to Azure Data Platform using ADF FTP Connector](https://techcommunity.microsoft.com/t5/modernization-best-practices-and/copy-files-from-mainframe-to-azure-data-platform-using-adf-ftp/ba-p/3042555)
  - [Mainframe files transfer to Azure Data Platform using SFTP](https://techcommunity.microsoft.com/t5/modernization-best-practices-and/mainframe-files-transfer-to-azure-data-platform-using-sftp/ba-p/3302194)
  - [Mainframe Dataset (Files) Transfer to Azure Storage (Blob) using Mainframe JCL](https://techcommunity.microsoft.com/t5/modernization-best-practices-and/mainframe-dataset-files-transfer-to-azure-storage-blob-using/ba-p/3597823)

- To address any latency, connectivity, technological, and regulatory considerations, you can transfer data to Azure Stack instead of Azure. Azure Stack Hub offers a set of cloud storage services. For more information, see [Azure Stack Hub storage: Differences and considerations](https://learn.microsoft.com/en-us/azure-stack/user/azure-stack-acs-differences?source=recommendations&view=azs-2206).

- You can also use MVT and CGX devices for z/VM and z/VSE mainframes.

- When you transfer tapes to Azure, you can compress and encrypt them to help transmit data safely at all stages. You can easily configure this functionality.

- You can also use this solution for bidirectional data interchange. In particular, you can recall the tape data to the mainframe and transform it into its original form.
  - With MDI, the process is similar to the transfer to Azure. You submit JCL statements that provide the specifics of the reverse transfer. The data can be transferred as tapes or as sequential files. The JCL configuration specifies the format.
  - With MVT CloudTAPE, the data is automatically recalled if you request it from the mainframe.

- Luminex CGX devices also support [Enterprise Systems Connection (ESCON)](https://wikipedia.org/wiki/ESCON) channel connectivity. The existing mainframe backup software sees the channel gateway as a recognized mainframe tape device. As a result, no software change is needed.

- When you transfer data from the datacenter to Azure, we recommend that you use Azure ExpressRoute, but you can also use the internet.

## Scenario details

Mainframe physical storage can be located on the mainframe processor or external to the mainframe. Processor storage, which is like memory for the mainframe, is located on the processor. Disk drives and tape drives are examples of external storage. Datasets in storage are organized into various logical record and block structures. These structures are defined by parameters like the dataset organization (DSORG) and record format (RECFM). Records in the dataset can be fixed or variable in length and stored in binary or text.

Secondary storage devices like [DASDs](https://wikipedia.org/wiki/Direct-access_storage_device) and [SASDs](https://wikipedia.org/wiki/Sequential_access) store data that's frequently and infrequently accessed. DASDs and SASDs differ in the way they provide access to data:

- DASDs are used for immediate data location and retrieval. With direct access, you can read or write data by going directly to a specific physical location on the device. As a result, DASDs are fast and efficient.
- SASDs, such as tapes, are inherently slower than DASDs. To access tape data, you start at one location and then go through successive locations until you find the data that you need. Mainframes use physical tapes and [virtual tape libraries (VTLs)](https://eikipedia.org/wiki/Virtual_tape_library), which are also called virtual tapes. Currently, virtual tapes are preferred over physical tapes.

The type of storage that you use depends on your needs. Many organizations need cold storage for compliance, regulatory, reporting, audit, and other purposes. Some organizations have data retention policies that require you to store data for nearly 100 years. Examples of this type of data include copies of prescriptions, patient records, customer reward history, and other information. Data that you store for the long term is mostly high in volume and accessed infrequently. Long-term storage generally costs less than active storage, which you typically access multiple times a day and which is frequently updated. Security considerations also affect your choice of storage, because cyberthreats are a constant presence.

Azure offers various storage solutions. You can use cold storage for infrequently accessed data and hot storage for frequently accessed data. The solution in this article uses the [Luminex](https://luminex.com) products MDI and MVT to transfer mainframe data to and from Azure to meet backup, archival, and other business needs.  

- [MDI](https://luminexmdi.com/) is a data transfer and co-processing platform. MDI uses Luminex [Channel Gateway X (CGX)](https://luminex.com/wp-content/uploads/2021/09/Luminex_CGX_Specifications.pdf) devices to process, transfer, and cache mainframe files. MDI provides secure and efficient exchange of data and workload sharing between z/OS mainframes and distributed systems. By using MDI products like Cloud Data Sharing, Big Data Transfer, and zKonnect, you can move files to Azure for backup, archival, data normalization, merging, and analysis. You can configure the transferred data to arrive in ASCII or EBCDIC format in Azure. [MDI Cloud Data Sharing](https://luminexmdi.com/solutions/luminex-mdi-cloud-data-sharing/) provides a way to migrate mainframe files like VSAM files, sequential files, and GDGs to Azure. MDI also supports integration with Azure messaging services. Applications that are hosted on Azure can use the mainframe files that are stored on Azure for modernization, reduced latency, and improved performance.

- [MVT](https://luminex.com/solutions/virtual-tape/) is a tape archival and backup platform. MVT uses Luminex CGX control unit software that emulates mainframe 3490 and 3590 tape drives, so you can use existing tape applications without change. The CGX environment provides a suite of products for tape encryption, vaulting, migration, replication, retrieval, disaster recovery, and high availability. Specifically, the [CloudTAPE](https://luminex.com/solutions/virtual-tape/cloudtape) product provides a way to migrate tape data to Azure.

MDI and MVT both use high-speed Channel Gateway X (CGX) controller devices to connect directly to the mainframe. These controllers are based on [Fiber Connection (FICON)](https://wikipedia.org/wiki/FICON), a transport protocol that mainframe servers and attached enterprise-class storage controllers support. FICON uses Fiber Channel as the underlying transport protocol. The CGX controllers also take advantage of network attached storage (NAS) and internal storage systems to supply the high levels of performance, scalability, reliability, security, and availability that enterprises demand. With FICON transport, I/O can be shared across multiple systems. FICON delivers optimal protocol efficiency. It also helps provide data integrity and security, even with increased distances between server and storage devices.

If you have high-data volumes, you can cluster CGX controllers. Typically, one CGX device offers a data-transfer speed of up to 800 MB/s. CGX controllers are available with up to four fiber channel ports or 1, 10, or 25 GbE. These controllers also offer up to four ports for connectivity to attached storage systems.

With MDI and MVT, no zIIP specialty engines are needed for data transfer, and no TCP/IP ports need to be opened to enable communication between the mainframe and Luminex devices. You plug the Luminex CGX devices directly into the mainframe just like any other mainframe storage device. If necessary, your existing legacy backup and tape management software can run in parallel. For MVT CloudTAPE and MDI Cloud Data Sharing, the millions of instructions per second (MIPS) consumption is minimal, because the transfer uses light-weight processes.

Azure is a proven landing place for your storage, backup, and long-term archival needs. File structures, such as VSAM datasets, flat files, and tape data, map to Azure data constructs within databases, structured files, and blob storage. Using Azure and Luminex for backup and recovery helps eliminate the cost associated with physical tape infrastructure, media, shipping, and off-site storage for vaulting. Features like redundant geographic replication and Azure auto-failover groups help provide data protection. Azure storage can store volume-intense data with cost efficiency, scalability, replication, and self-sustainability. Functionality is also available in Azure for retrieving data, gaining insights from data, and visualizing data.

### Potential use cases

Many scenarios can benefit from this solution. Possibilities include organizations with the following goals:

- Minimizing tape management and maintenance efforts.
- Modernizing legacy workloads.
- Finding backup and archival solutions.
- Extending their mainframe modernization by moving mainframe tapes to the cloud. Organizations that want to downsize their datacenter, not abandon it, might have this goal. If an organization doesn't use mainframe tapes heavily, the tapes might be a suitable candidate for migration.
- Transforming migrated data into a different format for cloud storage, such as converting EBCDIC data to ASCII, VSAM files to JSON, and sequential data to CSV format.
- Transferring tape metadata to Azure storage metadata.
- Providing new and refactored applications that are hosted on Azure with easy access to data.
- Expanding their cloud footprint.
- Easily monitoring, displaying, and reporting on mainframe files and tape data, and integrating this data with Azure services.
- Monetizing current and historical unlocked mainframe data and using it in cloud business intelligence and analytics tools.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- You can deploy this solution in multiple regions. You can implement geo-replication in the data layer.
- Clustered CGX controllers can provide an active-active recovery solution during failures.
- [MVT Synchronous Tape Matrix](https://luminex.com/solutions/virtual-tape/synchronous-tape-matrix/) provides reliability across multiple datacenters. Its infrastructure adjusts to failures without interruptions.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- The fully managed storage in this solution eliminates issues that are related to physical media safety. For example, shipping physical tapes in vehicles can damage the tapes or result in unauthorized access.
- [Luminex CGsafe](https://luminex.com/solutions/virtual-tape/cgsafe) provides tape compression and encryption. This product is part of the MVT family and is included with CloudTAPE. CGSafe encrypts and compresses tapes at ingestion, rest and in transit.
- When you use MDI Cloud Data Sharing, files are sent over HTTPS by using SSL. In Azure, you can encrypt the files at rest.
- Because the solution uses FICON and ESCON connectivity, you don't need to open any ports for data transfer.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- Pay-as-you-go pricing and muti-tiered models in Azure provide options to suit various cost and performance needs. For instance, if you access data infrequently, the Azure cool access tier is a good option for low-cost storage.
- The pricing of this solution depends on your volumne of tape data, your datacenter location, and your bandwidth. The cost also depends on which Azure services you use. These factors determine the hardware that you use, such as the number of Luminex CGX controllers. The factors also affect your software, service, licensing, and support costs.
- The data interchange doesn't require additional zIIP processors. As a result, you save on costs when you run the software.
- After the Luminex infrastructure is in place, you can use the Luminex hardware for other uses. For instance, you might already use MDI Cloud Data Sharing for file transfer. If you augment your environment with MDI zKonnect for streaming, you can save on costs, because you can purchase additional Luminex software and infrastructure at a significantly reduced price.
- If you already have Azure ExpressRoute infrastructure in place, you can use it for this solution.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

- The data transfer to Azure in this solution gives you flexibility for developing a backup strategy. You can enable automated regular or phased data migration. After you've installed a Luminex device in your datacenter, you can configure unidirectional or bidirectional communication, staged migration, or one-time migration. This flexibility provides support for implementing DevOps and Agile working principles and for immediate cloud adoption.
- You can take advantage of Azure capabilities for mainframe backup, archive, and disaster recovery.
- You can deploy continuous integration/continuous delivery (CI/CD) pipelines on Azure to manage data movement, transformation, and control activities.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

- With Azure services, various performance options and tiers are available. For instance, block blob storage accounts offer standard and premium performance tiers. You can choose the tier that best meets your needs.
- Predefined access and life cycle management in Azure make it easy to optimize the performance of specific use cases.
- The tape emulation software in this solution uses the FICON I/O system. By using this system, you can reduce CPU time, increase data transmission speed, and reduce elapsed time.
- [Luminex Replication](https://luminex.com/solutions/virtual-tape/luminex-replication/) can replicate data to one or many targets. A target can be one or more disaster recovery sites that each have a mainframe and CGX controller installed on the property. You can also preconfigure a target through Azure geo-replication. If you use Azure and other private or public clouds, you can also use a hybrid strategy for disaster recovery. Essentially, you can use the replication strategy that best meets your requirements. Examples include one-to-one, one-to-many, many-to-many, and cascading strategies.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Daniel Saunders](https://www.linkedin.com/in/daniel-saunders-b0735491/) | Principal Software Engineer
- [Bhuvi Vatsey](https://www.linkedin.com/in/bvatsey) | Senior TPM

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- For more information, or if you're implementing a similar solution and want to share your experiences or feedback, contact the [Microsoft Legacy Modernization Azure Core Engineering (ACE) team](mailto:legacy2azure@microsoft.com).
- For more information about Luminex, see [Luminex solutions](https://luminex.com/solutions).
- For information about third-party data transfer solutions, see [Third-party archive solutions](https://learn.microsoft.com/en-us/azure/architecture/example-scenario/mainframe/move-archive-data-mainframes#third-party-archive-solutions).

## Related resources

- [Modernize mainframe and midrange data](https://learn.microsoft.com/en-us/azure/architecture/example-scenario/mainframe/modernize-mainframe-data-to-azure)
- [Move archive data from mainframe systems to Azure](https://learn.microsoft.com/en-us/azure/architecture/example-scenario/mainframe/move-archive-data-mainframes)
- [Replicate mainframe data by using Precisely Connect](https://learn.microsoft.com/en-us/azure/architecture/example-scenario/mainframe/mainframe-replication-precisely-connect)
- [Mainframe and midrange data replication to Azure using Qlik](https://learn.microsoft.com/en-us/azure/architecture/example-scenario/mainframe/mainframe-midrange-data-replication-azure-qlik)
- [Mainframe and midrange data replication to Azure using tcVISION](https://learn.microsoft.com/en-us/azure/architecture/example-scenario/mainframe/mainframe-data-replication-azure-tcvision)
- [Migrate mainframe data tier to Azure with mLogica LIBER*IRIS](https://learn.microsoft.com/en-us/azure/architecture/example-scenario/mainframe/mainframe-data-replication-azure-data-platform)
- [Mainframe modernization using Model9](https://learn.microsoft.com/en-us/azure/architecture/example-scenario/mainframe/mainframe-modernization-model9)
