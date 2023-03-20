This article presents a solution for using Luminex products to transfer mainframe data to and from Azure to meet backup, archival, and other business needs. Key components in the solution include the Luminex mainframe data integration (MDI) platform's Cloud Data Sharing and the Luminex mainframe virtual tape (MVT) platform's CloudTAPE.

*Apache® and [Apache Kafka](https://kafka.apache.org) are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by the Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="content" source="media/luminex-mainframe-file-tape-transfer-architecture.png" alt-text="Architecture diagram that shows how Luminex products migrate mainframe file and tape data to Azure." lightbox="media/luminex-mainframe-file-tape-transfer-architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/luminex-mainframe-file-tape-transfer-architecture.vsdx) of this architecture.*

### Dataflow

1. On a mainframe, secondary storage devices include direct-access storage devices (DASDs) and sequential-access storage devices (SASDs).

1. DASDs are mounted on the mainframe.

1. A tape is a type of SASD that's attached to the mainframe as external storage.

1. The MDI platform sends information that can be stored on files to Azure. Examples include system management facilities (SMF) data, Virtual Storage Access Method (VSAM) files, sequential files, and generation data groups (GDGs). MDI hardware that's installed in the datacenter includes Luminex Channel Gateway X (CGX) controllers and Luminex MDI servers.

1. MVT CloudTAPE provides tape archival and backup. MVT hardware that's installed in the datacenter includes Luminex CGX controllers and CloudTAPE servers.

1. MDI and MVT use CGX controller devices that are based on the Fibre Connection (FICON) protocol. These devices connect directly to the mainframe. No System z Integrated Information Processor (zIIP) specialty engines are needed for data transfer. There's no Luminex agent on the mainframe, and no TCP/IP ports need to be open for communication between the mainframe and Luminex devices.

1. The mainframe data is transferred to Azure through a private, secure Azure ExpressRoute connection.

1. Luminex MDI zKonnect and other services stream the file data for big data analysis on Azure. For instance, system data like mainframe logs and SMF data is streamed to Azure Event Hubs. Azure services ingest the data and then process, transform, and project it.

1. MDI uses Luminex CGX devices to process, transfer, and cache file data. Two options are available:
   - Job control language (JCL) statements are submitted. Luminex provides statements that specify information about input files, the Azure destination, keys and security information, data transformation, and cloud file formats. Organizations that use the Luminex procedure for data transfer can use their own JCL statements. When the job finishes, a return code of zero indicates a successful transfer.
   - The job is monitored from the MDI UI. An operations team can use a combination of the scheduler, the mainframe, and the MDI UI to monitor and troubleshoot jobs. The MDI UI provides information like the job name, the job ID, the user or group, the start time, and the elapsed time. MDI retry mechanisms engage if the file transfer doesn't initially succeed.

   The job can be configured to cache the files in local storage before the transfer. After the transfer finishes, that local storage is removed.

1. MVT CloudTAPE sends mainframe tape data to Azure data stores like Azure Blob Storage, Azure Files, and Azure Data Lake Storage. The data can be structured and unstructured. The transfer doesn't use JCL statements. Instead, MVT CloudTAPE moves or replicates mainframe tapes in IBM 3490 or 3590 format that CGX controllers emulate.

1. Azure services provide data processing, storage, analytics, and visualization capabilities.

### Components

- [ExpressRoute](https://azure.microsoft.com/products/expressroute) extends on-premises networks to the Microsoft cloud. ExpressRoute uses a connectivity provider to establish private connections between on-premises data and Microsoft cloud services.

- [Azure Files](https://azure.microsoft.com/products/storage/files) is a service that's part of [Azure Storage](/azure/storage/common/storage-introduction). Azure Files offers fully managed file shares in the cloud. Azure file shares are accessible via the industry-standard Server Message Block (SMB) protocol. This solution uses Luminex MDI and MVT to transfer mainframe files to Azure Files.

- [Blob Storage](https://azure.microsoft.com/products/storage/blobs) is a service that's part of Storage. Blob Storage provides optimized cloud object storage for massive amounts of unstructured data. In this solution, Blob Storage provides a way to archive hot and cold mainstream data.

- In this solution, Luminex products can transfer mainframe data to several Azure databases:

  - [Azure SQL](https://azure.microsoft.com/services/azure-sql) is a family of Azure databases that are powered by the SQL Server engine.
  - [Azure SQL Database](https://azure.microsoft.com/services/sql-database) is a fully managed platform as a service (PaaS) database engine that's part of the Azure SQL family. With AI-powered, automated features, SQL Database handles database management functions like upgrading, patching, backups, and monitoring.
  - [Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql) is a fully managed relational database service that's based on the community edition of the open-source PostgreSQL database engine.
  - [Azure Database for MySQL](https://azure.microsoft.com/products/mysql) is a fully managed relational database service that's based on the community edition of the open-source MySQL database engine.

- [Event Hubs](https://azure.microsoft.com/services/event-hubs) is a fully managed big data streaming platform. In this solution, [Luminex zKonnect](https://luminexmdi.com/solutions/luminex-mdi-zkonnect) streams mainframe data to Event Hubs in near real time. Event Hubs provides an endpoint that's compatible with Apache Kafka producer and consumer APIs. Most existing Apache Kafka client applications use these APIs as an alternative to running their own Apache Kafka clusters.

- [Power BI](https://powerbi.microsoft.com) is a collection of software services and apps that display analytics information. This solution uses mainframe data that comes from various sources and has varying structures. Power BI is used to turn the data into coherent, visually immersive, and interactive insights.

- [Data Lake Storage](https://azure.microsoft.com/products/storage/data-lake-storage) provides a way to perform big data analytics with low-cost, tiered storage and high throughput.

### Alternatives

- Instead of using third-party solutions for data transfer, you can use a Microsoft solution. For information about transferring data from mainframe and midrange systems to Azure, see [Move archive data from mainframe systems to Azure](./move-archive-data-mainframes.yml). For information about specific Microsoft solutions, see the following resources:
  - [Copy files from a mainframe to Azure by using the Azure Data Factory FTP connector](https://techcommunity.microsoft.com/t5/modernization-best-practices-and/copy-files-from-mainframe-to-azure-data-platform-using-adf-ftp/ba-p/3042555)
  - [Transfer mainframe files to Azure by using SFTP](https://techcommunity.microsoft.com/t5/modernization-best-practices-and/mainframe-files-transfer-to-azure-data-platform-using-sftp/ba-p/3302194)
  - [Transfer a mainframe dataset to Azure Blob Storage by using a mainframe JCL](https://techcommunity.microsoft.com/t5/modernization-best-practices-and/mainframe-dataset-files-transfer-to-azure-storage-blob-using/ba-p/3597823)

- To address any latency, connectivity, technological, and regulatory considerations, you can transfer data to Azure Stack instead of to Azure. Azure Stack Hub offers a set of cloud storage services. For more information, see [Azure Stack Hub storage: Differences and considerations](/azure-stack/user/azure-stack-acs-differences?source=recommendations&view=azs-2206).

- You can also use Luminex MVT and CGX devices for IBM z/VM and z/VSE mainframes.

- When you transfer tapes to Azure, you can compress and encrypt them to help transmit data safely at all stages. You can easily configure this functionality.

- You can also use this solution for bidirectional data interchange. You can recall the tape data to the mainframe and transform it into its original form.
  - With MDI, the process is similar to the transfer to Azure. You submit JCL statements that provide the specifics of the reverse transfer. The data can be transferred as tapes or as sequential files. The JCL configuration specifies the format.
  - With MVT CloudTAPE, the data is automatically recalled if you request it from the mainframe.

- Luminex CGX devices also support [Enterprise Systems Connection (ESCON)](https://wikipedia.org/wiki/ESCON) channel connectivity. The existing mainframe backup software sees the channel gateway as a recognized mainframe tape device. As a result, no software change is needed.

- This solution uses ExpressRoute to transfer data from the datacenter to Azure. We recommend this approach, but you can also use the internet for data transfer.

## Scenario details

Mainframe physical storage can be located on the mainframe processor, or it can be external to the mainframe. Processor storage, which is like memory for the mainframe, is located on the processor. Disk drives and tape drives are examples of external storage. Datasets in storage are organized into various logical record and block structures. Parameters like the dataset organization (DSORG) and record format (RECFM) define these data structures. Records in the dataset can be fixed or variable in length, and they can be stored in binary or text format.

Secondary storage devices like [DASDs](https://wikipedia.org/wiki/Direct-access_storage_device) and [SASDs](https://wikipedia.org/wiki/Sequential_access) store data that's either frequently or infrequently accessed.

- DASDs are used for immediate data location and retrieval. With direct access, you can read or write data by going directly to a specific physical location on the device. As a result, DASDs are fast and efficient.
- SASDs, such as tapes, are inherently slower than DASDs. To access tape data, you start at one location and then go through successive locations until you find the data that you need. Mainframes use physical tapes and [virtual tape libraries (VTLs)](https://wikipedia.org/wiki/Virtual_tape_library), which are also called *virtual tapes*. Currently, virtual tapes are preferred over physical tapes.

The type of storage that you use depends on your needs. Many organizations need cold storage for compliance, regulatory, reporting, audit, or other purposes. Some organizations have data retention policies that require you to store data for nearly 100 years. Examples of this type of data include copies of prescriptions, patient records, customer reward history, and other information. Data that you store for the long term is mostly high in volume and accessed infrequently. Long-term storage generally costs less than active storage, which you typically access multiple times a day and which is frequently updated. Security considerations also affect your choice of storage. Cyberattacks are a constant threat.

Azure offers various storage solutions and is a proven landing place for your storage, backup, and long-term archival needs. You can use cold storage for infrequently accessed data and hot storage for frequently accessed data. Mainframe file structures, such as VSAM datasets, flat files, and tape data, map to Azure data constructs within databases, structured files, and blob storage. Azure storage can store volume-intense data with cost efficiency, scalability, replication, and self-sustainability. Azure services can also help you retrieve your data, visualize your data, and gain insights from your data.

The solution in this article uses the [Luminex](https://luminex.com) MDI and MVT platforms to transfer mainframe data to and from Azure to meet backup, archival, and other business needs.

- [Luminex MDI](https://luminexmdi.com) is a data transfer and coprocessing platform. MDI uses Luminex [CGX](https://luminex.com/wp-content/uploads/2021/09/Luminex_CGX_Specifications.pdf) devices to process, transfer, and cache mainframe files. MDI provides secure and efficient exchange of data and workload sharing between z/OS mainframes and distributed systems. By using MDI products like Cloud Data Sharing, Big Data Transfer, and zKonnect, you can move files to Azure for backup, archival, data normalization, merging, and analysis. You can configure the transferred data to arrive in ASCII or EBCDIC format in Azure. [MDI Cloud Data Sharing](https://luminexmdi.com/solutions/luminex-mdi-cloud-data-sharing) provides a way to migrate mainframe files like VSAM files, sequential files, and GDGs to Azure. MDI also supports integration with Azure messaging services. Applications that are hosted on Azure can use the mainframe files that are stored on Azure for modernization, reduced latency, and improved performance.

- [Luminex MVT](https://luminex.com/solutions/virtual-tape) is a tape archival and backup platform. MVT uses Luminex CGX control unit software that emulates mainframe 3490 and 3590 tape drives, so you can use existing tape applications without change. The CGX environment provides a suite of products for tape encryption, vaulting, migration, replication, retrieval, disaster recovery, and high availability. Specifically, the [CloudTAPE](https://luminex.com/solutions/virtual-tape/cloudtape) product provides a way to migrate tape data to Azure.

MDI and MVT both use high-speed CGX controller devices to connect directly to the mainframe. These controllers are based on [FICON](https://wikipedia.org/wiki/FICON), a transport protocol that mainframe servers and attached enterprise-class storage controllers support. FICON uses Fibre Channel as the underlying transport protocol. The CGX controllers also take advantage of network attached storage (NAS) and internal storage systems to supply the high levels of performance, scalability, reliability, security, and availability that enterprises demand. With FICON transport, I/O can be shared across multiple systems. FICON delivers optimal protocol efficiency. It also helps provide data integrity and security, even with increased distances between server and storage devices.

With MDI and MVT, no zIIP specialty engines are needed for data transfer, and no TCP/IP ports need to be open to enable communication between the mainframe and Luminex devices. You plug the Luminex CGX devices directly into the mainframe just like any other mainframe storage device. If necessary, your existing legacy backup and tape management software can run in parallel. For MVT CloudTAPE and MDI Cloud Data Sharing, the millions of instructions per second (MIPS) consumption is minimal because the transfer uses lightweight processes.

### Potential use cases

Many scenarios can benefit from this solution. Possibilities include organizations with the following goals:

- Minimizing tape management and maintenance efforts.
- Modernizing legacy workloads.
- Finding backup and archival solutions.
- Extending their mainframe modernization by moving mainframe tapes to the cloud. Organizations might have this goal if they want to downsize their datacenter but not abandon it. If an organization doesn't use mainframe tapes heavily, the tapes might be a suitable candidate for migration.
- Transforming migrated data into a different format for cloud storage, such as converting EBCDIC data to ASCII, VSAM files to JSON, and sequential data to CSV format.
- Transferring tape metadata to Azure storage metadata.
- Providing new and refactored applications that are hosted on Azure with easy access to data.
- Expanding their cloud footprint.
- Easily monitoring, displaying, and reporting on mainframe files and tape data, and integrating this data with Azure services.
- Monetizing current and historical unlocked mainframe data and using it in cloud business intelligence and analytics tools.

If you're implementing a similar solution and want to share your experiences or feedback, contact the [Microsoft Legacy Modernization Azure Core Engineering (ACE) team](mailto:legacy2azure@microsoft.com).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- You can deploy this solution in multiple regions, and you can implement geo-replication in the data layer. Azure auto-failover groups also help provide data protection.
- Clustered CGX controllers can provide an active-active recovery solution during a failure.
- [MVT Synchronous Tape Matrix](https://luminex.com/solutions/virtual-tape/synchronous-tape-matrix) provides reliability across multiple datacenters. Its infrastructure adjusts to failures without interruption.
- [Luminex Replication](https://luminex.com/solutions/virtual-tape/luminex-replication) can replicate data to one or many targets. A target can be one or more disaster recovery sites that each have a mainframe and CGX controller installed on the property. You can also preconfigure a target through Azure geo-replication. If you use Azure and other private or public clouds, you can also use a hybrid strategy for disaster recovery. Essentially, you can use the replication strategy that best meets your requirements. Examples include one-to-one, one-to-many, many-to-many, and cascading strategies.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- The fully managed storage in this solution eliminates issues that are related to physical media safety. Examples are damage or unauthorized access that might occur when you ship physical tapes in vehicles.
- [Luminex CGSafe](https://luminex.com/solutions/virtual-tape/cgsafe) provides tape compression and encryption. This product is part of the MVT family and is included with CloudTAPE. CGSafe encrypts and compresses tapes during ingestion, at rest, and in transit.
- When you use MDI Cloud Data Sharing, files are sent over HTTPS by using SSL. In Azure, you can encrypt the files at rest.
- Because the solution uses FICON and ESCON connectivity, you don't need to open any ports for data transfer.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- Pay-as-you-go pricing and multi-tiered models in Azure provide options to suit various cost and performance needs. For instance, if you access data infrequently, the Azure cool access tier is a good option for low-cost storage.
- The pricing of this solution depends on your volume of tape data, your datacenter location, and your bandwidth. The cost also depends on which Azure services you use. These factors determine the hardware that you use, such as the number of Luminex CGX controllers. The factors also affect your software, service, licensing, and support costs.
- The data interchange doesn't require zIIP processors. As a result, you save on costs when you run the software.
- After the Luminex infrastructure is in place, you can use the Luminex hardware for other purposes. For instance, you might already use MDI Cloud Data Sharing for file transfer. If you augment your environment with MDI zKonnect for streaming, you can save on costs because you can purchase additional Luminex software and infrastructure at a significantly reduced price.
- If you already have an ExpressRoute infrastructure in place, you can use it for this solution.
- Using Azure and Luminex for backup and recovery helps you eliminate some costs that are associated with physical tape infrastructure. Examples include media and shipping expenses and off-site storage for vaulting.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

- The data transfer to Azure in this solution gives you flexibility when you develop a backup strategy. You can enable automated, regular migration or phased-data migration. After you've installed a Luminex device in your datacenter, you can configure unidirectional or bidirectional communication, staged migration, or one-time migration. This flexibility provides support for implementing DevOps and Agile working principles and for immediate cloud adoption.
- You can take advantage of Azure capabilities for mainframe backup, archive, and disaster recovery.
- You can deploy continuous integration/continuous delivery (CI/CD) pipelines on Azure to manage data movement, transformation, and control activities.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

- If you have a high volume of data, you can cluster CGX controllers. Typically, one CGX device offers a data-transfer speed of up to 800 megabytes per second (MB/s). CGX controllers are available with up to four Fibre Channel ports or 1 Gigabit Ethernet (GbE), 10 GbE, or 25 GbE. These controllers also offer up to four ports for connectivity to attached storage systems.
- In Azure services, various performance options and tiers are available. For instance, block blob storage accounts offer standard and premium performance tiers. You can choose the tier that best meets your needs.
- Predefined access and life cycle management in Azure make it easy to optimize the performance of specific use cases.
- The tape emulation software in this solution uses the FICON I/O system. By using this system, you can reduce CPU time, increase data transmission speed, and reduce elapsed time.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Daniel Saunders](https://www.linkedin.com/in/daniel-saunders-b0735491) | Principal Software Engineer
- [Bhuvi Vatsey](https://www.linkedin.com/in/bvatsey) | Senior Technical Program Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- For more information, contact the [Microsoft Legacy Modernization Azure Core Engineering (ACE) team](mailto:legacy2azure@microsoft.com).
- For information about third-party data transfer solutions, see [Third-party archive solutions](./move-archive-data-mainframes.yml#third-party-archive-solutions).

## Related resources

- [Modernize mainframe and midrange data](./modernize-mainframe-data-to-azure.yml)
- [Move archive data from mainframe systems to Azure](./move-archive-data-mainframes.yml)
- [Replicate mainframe data by using Precisely Connect](./mainframe-replication-precisely-connect.yml)
- [Mainframe and midrange data replication to Azure using Qlik](./mainframe-midrange-data-replication-azure-qlik.yml)
- [Mainframe and midrange data replication to Azure using tcVISION](./mainframe-data-replication-azure-tcvision.yml)
- [Migrate a mainframe data tier to Azure by using mLogica LIBER*IRIS](./mainframe-data-replication-azure-data-platform.yml)
- [Mainframe modernization using Model9](./mainframe-modernization-model9.yml)
