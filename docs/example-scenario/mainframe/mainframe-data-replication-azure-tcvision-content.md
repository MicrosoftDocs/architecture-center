tcVISION is a mainframe manager system. It provides an IBM mainframe integration solution for mainframe data replication, data synchronization, data migration, and change data capture (CDC) to multiple Azure Data Platform services.

## Architecture

![Diagram of the Mainframe to Azure Data Platform architecture](./images/mframe-data-replication-to-azure-architecture.png)

> Under the architecture diagram, include this sentence and a link to the Visio file or the PowerPoint file: 

*Download a [Visio file](https://arch-center.azureedge.net/Mainframe-Realtime-Batch-Data-Replication-to-Azure-using-tcVISION.vsdx) of this architecture.*

The tcVISION logo is a trademark of its respective company. No endorsement is implied by the use of this mark.

### Workflow

The following workflow corresponds to the previous architecture diagram:

1. The tcVISION database management system supports change data capture from many mainframe-based databases. For example, Db2, IMS/DB, Software AG ADABAS, CA Datacom, CA IDMS, and so on. tcVISION provides log-based CDC agents to capture the change data on the record level. This log-based CDC puts negligible overhead on production source databases.
1. tcVISION also supports CDC from virtual storage access method (VSAM) files.
1. A task starts on the mainframe. Started tasks (STC) are created on Mainframe as part of tcVISION software installation. Two vital STC are:
   * Capture Agent, which captures changed data from the source.
   * Apply Agent, which uses DBMS-specific APIs for efficiently writing changed data to the target.
   > [!NOTE]
   > For Db2 z/OS, tcVISION also offers an Agentless CDC solution by way of a Db2 user defined type (UDT) that doesn't need a started task.

1. The Open Platform Manager acts as a replication server. This server contains utilities for automatic data mapping to generate metadata for sources and targets. It contains the rule set for extracting the data from the source. And the server transforms and processes the data for the target systems and writes the data into the targets. You can install this component in Linux, Unix, and Windows Operating System. 
1. The tcVISION Control Board or dashboard provides administration, review, operation, control, and monitoring of the data exchange processes. The tcVISION command line utilities help automate data exchange processes and manage the unattended operations of the data synchronization process.
1. The tcVISION Apply Agent uses database management system-specific APIs. These APIs efficiently implement real-time data changes in combination with CDC technology at the source to the target Azure Data Services (as in, database and files).
1. tcVISION supports direct streaming the changed data into Azure Event Hub or Kafka. These events are then processed by an Azure Logic App, function, or a custom solution in the virtual machine.
1. The Azure Data Platform targets supported by tcVISION include Azure SQL DB, Azure Database for PostgreSQL and MySQL, Cosmos DB, Azure Data Lake Storage, and so on.
1. After data lands in Azure Data Platform, it's consumed by Azure services or others that are permitted to see it. For example, Power BI, Synapse Analytics, or even a custom application.
1. The tcVISION product can even reverse-sync capture changes from an Azure database platform (Azure SQL DB, MySQL, PostgreSQL, ADLS, and so on) and write them back to the mainframe data tier.
1. The mainframe database backup and unload files are copied to Azure VM with tcVISION for bulk load processing.
1. The tcVISION bulk load performs an initial target database load using mainframe source data. Source data can be read directly from the mainframe data store or from a mainframe backup or unload. The bulk load provides an automatic translation of mainframe data types, such as extended binary coded decimal interchange code (EBCDIC) packed fields. Typically, for the best performance, use the backup or unload data versus a direct read of the mainframe database. Because moving unload or backup data to the requisite tcVISION Azure VM and using native database loaders minimizes network IO and reduces load time.

### Components

A list of the components in the architecture follow.

#### Networking and identity components

  - [Azure ExpressRoute](/azure/expressroute/expressroute-introduction) - ExpressRoute lets you extend your on-premises networks into the Microsoft Cloud over a private connection handled by a connectivity provider. With ExpressRoute, you can establish connections to cloud services, such as Microsoft Azure and Microsoft Office 365.
  - [Azure VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) - A VPN gateway is a specific type of virtual network gateway that sends encrypted traffic between an Azure virtual network and an on-premises location over the public Internet.
  - [Azure AD](/azure/active-directory/fundamentals/active-directory-whatis) - Azure Active Directory is an identity and access management service that you can sync with an on-premises directory.

#### Application components

  - [Azure Logic App](/azure/logic-apps/logic-apps-overview) - Logic Apps help create and run automated recurring tasks and processes on a schedule. You can call services inside and outside Azure, such as HTTP or HTTPS endpoints, post messages to Azure services such as Azure Storage and Azure Service Bus, or upload files to a file share.
  - [Functions](/azure/azure-functions/functions-overview) - Azure Functions lets you run small pieces of code, functions without worrying about application infrastructure. With Azure Functions, the cloud infrastructure provides the up-to-date servers you need to keep your application running at scale.
  - [Azure VM](https://azure.microsoft.com/services/virtual-machines/) - Azure VMs are on-demand, scalable computing resources that are available with Azure. An Azure VM provides the flexibility of virtualization. But it eliminates the maintenance demands of physical hardware. Azure VMs offer a choice of operating systems, including Windows and Linux.

#### Storage components

  - [Azure Storage](/azure/storage/common/storage-introduction) - This offers un-managed storage solutions like Blob, Tables, Files, and Queues. Files can particularly come in handy for reengineered Mainframe solutions, this provides an effective add-on with the managed SQL storage.
  - [Azure SQL](/azure/azure-sql/database/sql-database-paas-overview) - This is Azure’s fully managed PaaS service for SQL Server. The relational data could be migrated and used efficiently with other Azure services (Azure SQL MI, Azure SQL VM, PostgreSQL, MariaDB, MySQL etc.)
  - [Cosmos DB](/azure/cosmos-db/introduction) - Cosmos DB is no-SQL offering that you can use to migrate non-tabular data off the Mainframe.

#### Monitoring components

  - [Azure Monitor](/azure/azure-monitor/overview) - Azure Monitor delivers a comprehensive solution for collecting, analyzing, and acting on telemetry from cloud and on-premises environments.
  - [Application Insight](/azure/azure-monitor/app/app-insights-overview) - Application telemetry is sent to Application Insight for analysis and presentation.
  - [Azure Monitor Logs](/azure/azure-monitor/logs/data-platform-logs) - Azure Monitor Logs is a feature of Azure Monitor that collects and organizes log and performance data from monitored resources. Data from different sources such as platform logs from Azure services, log and performance data from virtual machines agents, and usage and performance data from applications can be consolidated into a single workspace so they can be analyzed together using a sophisticated query language that's capable of quickly analyzing millions of records.
  - [Log Analytics](/azure/azure-monitor/log-query/log-query-overview) - Log queries help you gain the value of the data collected in Azure Monitor Logs. A powerful query language lets you join data from multiple tables, aggregate large sets of data, and perform complex operations with minimal code.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

* Set up tcVISION Open Platform Manager (OPM) on Azure virtual machines deployed in separate availability zones to provide high availability. In case of failures, a secondary tcVISION OPM is activated and it communicates its IP address to tcVISION Mainframe Manager. Mainframe starts communicating with the new tcVISION OPM that continues processing at its next logical restart point, using a combination of logical unit of work (LUW) and restart files.
* Design database services in the Azure support zone redundancy to fail over to a secondary node in case of an outage or during a maintenance window.
* Use Azure Monitor and Application Insights on the top of Log Analytics to monitor Health of the Azure Resource. You can set alerts for proactive management.
* For more information on resiliency in Azure, see [Designing reliable Azure applications](/azure/architecture/framework/resiliency/app-design).

### Scalability

* CDC - Set up tcVISION scaling for CDC processing by running multiple parallel replication streams. First, analyze the files included in logical transactions.These files must be processed together in sequence. The tcVISION CDC process ensures the integrity of each logical transaction, and these files must be processed together. For instance, sets of tables that don't participate in common transactions might be divided into parallel tasks by creating multiple processing scripts.
* Bulk Load - tcVISION can run parallel concurrent bulk load processing simultaneously on a single Azure VM or on multiple Azure VMs giving horizontal scalability. Bulk load large tables faster by splitting the process into multiple tasks, either by arbitrary intervals, or by way of row filtering. Row filtering can use a key, partition key, date, and so on.
* Auto scaling - Azure SQL DB serverless compute tier provides an auto scaling option based on workload. Other Azure databases can be scaled up and down using automation to meet the workload demands.
* For more information, see [Autoscaling best practices in Azure](/azure/architecture/best-practices/auto-scaling).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

* Control authentication and access for tcVISION with Azure Active Directory.
* Encrypt data transfer between tcVISION products (Mainframe to Azure) with transport layer security (TLS).
* Use express route or site to site VPN for private and efficient connection to Azure from an on-premise environment.
* Authenticate Azure resources with Azure AD and manage permissions with role-based access control.
* Use the database services in Azure to support various security options like data encryption at rest (TDE), data encryption in transit (TLS), data encryption while processing, as in always encrypted.
* For guidelines on designing secure solutions, see the [Azure security documentation](/azure/security).
* To find out your security baseline, see [Azure security baseline assessment](https://aka.ms/AzureSecurityBaselines).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview). Use the [Azure pricing calculator](https://azure.microsoft.com/en-us/pricing/calculator) to estimate the cost of implementing this solution.

## Scenario details

Mainframes are servers that process a large number of transactions. Mainframe applications generate and consume large amounts of data daily. With the introduction of public clouds that offer elasticity, cost optimization, ease of use, and easy integration, many x86 and mainframe applications are moving to the Cloud. It's now important for organizations to have a well-designed mainframe to Cloud data integration and migration strategy.

This reference architecture shows how to integrate an IBM Z (Mainframe) data tier with Azure Cloud Data Platform. To integrate Mainframe with Azure Cloud Data Platform, use [tcVISION](https://www.bossoftware.de/index.php/en/products/tcvision-real-time-mainframe-data-integration) software provided by [B.O.S. Software](https://www.bossoftware.de/index.php/en/products/tcvision-real-time-mainframe-data-integration), [Treehouse Software](https://www.treehouse.com/tcVISION.shtml).

### Potential use cases

This solution is ideal for large-scale data migrations to Azure Data Platform. Consider this scenario for the following use cases:

* Full migration of a mainframe data tier: In this use case, a customer wants to move all their Db2, IMS, IDMS, files, and so on from Mainframe to Azure Data Platform.
* Co-existence of Mainframe and Azure based applications: In this use case, a customer often has a requirement to support a bidirectional sync between Mainframe and Azure Data Platform.
* Archival: In this use case, a customer wants to store data for audit and compliance purposes but doesn't want to access this data frequently. Azure storage provides a low-cost solution to store archive data.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

 - [Sandip Khandelwal](https://www.linkedin.com/in/sandip-khandelwal-64326a7/) | Senior Engineering Architect

Other contributors:

 - [Liz Casey](https://www.linkedin.com/in/elizabethhlizfloriocasey) | (Senior Content Developer)
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

* [Application Insight](/azure/azure-monitor/app/app-insights-overview)
* [Azure AD](/azure/active-directory/fundamentals/active-directory-whatis)
* [Azure Data Engineering for mainframe and midrange modernization](mailto:datasqlninja@microsoft.com).
* [Azure ExpressRoute](/azure/expressroute/expressroute-introduction)
* [Azure Functions](/azure/azure-functions/functions-overview)
* [Azure Logic App](/azure/logic-apps/logic-apps-overview)
* [Azure Monitor](/azure/azure-monitor/overview)
* [Azure Monitor Logs](/azure/azure-monitor/logs/data-platform-logs)
* [Azure SQL](/azure/azure-sql/database/sql-database-paas-overview)
* [Azure Storage](/azure/storage/common/storage-introduction)
* [Azure VM](https://azure.microsoft.com/services/virtual-machines/)
* [Azure VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways)
* [Cosmos DB](/azure/cosmos-db/introduction)
* [Data migration guide](https://datamigration.microsoft.com/)
* [Log Analytics](/azure/azure-monitor/log-query/log-query-overview)

## Related resources

* [Architect a data platform in Azure](/learn/paths/architect-data-platform/)
* [Azure Artifacts](/azure/devops/artifacts/start-using-azure-artifacts)
* [Azure Boards](/azure/devops/boards/get-started/what-is-azure-boards)
* [Azure Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines)
* [Azure Repos](/azure/devops/repos/get-started/what-is-repos)
* [Azure Test Plans](/azure/devops/test/overview?view=azure-devops)
* [Data platform modernization](/learn/modules/introduction-data-platform-modernization/)
* [Design your data migration to Azure](/learn/modules/design-your-migration-to-azure/)
* [Replicate and synch mainframe data in Azure](/azure/architecture/reference-architectures/migration/sync-mainframe-data-with-azure)
