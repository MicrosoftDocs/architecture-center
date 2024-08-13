Rocket® Data Replicate and Sync (RDRS), formerly tcVISION, is a data replication solution developed by Rocket Software. RDRS provides an IBM mainframe integration solution for mainframe data replication, data synchronization, data migration, and change data capture (CDC) for several Azure data platform services.

## Architecture

:::image type="content" source="./media/mainframe-realtime-batch-data-replication-azure-rdrs.svg" alt-text="Architecture diagram of the dataflow for migrating a mainframe to the Azure data platform." border="false" lightbox="./media/mainframe-realtime-batch-data-replication-azure-rdrs.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/mainframe-realtime-batch-data-replication-azure-rdrs.vsdx) of this architecture.*

### Workflow

1. The RDRS data replication solution supports CDC from many mainframe-based databases, including IBM Db2, IBM Information Management System (IMS) DB, Adabas for Software AG, CA Datacom, and Computer Associates Integrated Data Management System (CA IDMS). RDRS provides log-based CDC agents to capture the change data on the record level. This log-based CDC puts negligible overhead on production source databases.
1. RDRS supports CDC from Virtual Storage Access Method (VSAM) files.
1. A task starts on the mainframe. Started tasks, or STCs, are created on the mainframe as part of RDRS software installation. Two vital STCs are:
   - Capture agent, which captures changed data from the source.
   - Apply agent, which uses database management system (DBMS)-specific APIs to efficiently write changed data to the target.
   > [!NOTE]
   > For Db2 z/OS, RDRS also offers an agentless CDC solution by way of a Db2 user-defined type (UDT) that doesn't need STCs.

1. The open platform manager (OPM) acts as a replication server. This server contains utilities for automatic data mapping to generate metadata for sources and targets. It also contains the ruleset to extract data from the source. The server transforms and processes the data for the target systems and writes the data into the targets. You can install this component on Linux, Unix, and Windows operating systems.
1. The RDRS dashboard provides administration, review, operation, control, and monitoring of the data exchange processes. The RDRS command-line utilities automate data exchange processes and manage unattended operations of the data synchronization process.
1. The RDRS apply agent uses DBMS-specific APIs. These APIs efficiently implement real-time data changes in combination with CDC technology at the source to the target Azure data services, meaning the database and files.
1. RDRS supports direct streaming of the changed data into Azure Event Hubs or Kafka. Then Azure Logic Apps, a function, or a custom solution in the virtual machine (VM) processes these events.
1. The Azure data platform targets that are supported by RDRS include Azure SQL Database, Azure Database for PostgreSQL, Azure Database for MySQL, Azure Cosmos DB, Azure Data Lake Storage, and others.
1. Data that lands in the Azure data platform is consumed by Azure services or other platforms that are permitted to see it. Examples include Power BI, Azure Synapse Analytics, or custom applications.
1. RDRS can reverse synchronize capture changes from an Azure database platform (like SQL Database, Azure Database for MySQL, Azure Database for PostgreSQL, or Data Lake Storage) and write them back to the mainframe data tier.
1. The mainframe database backup and unload files are copied to an Azure VM by using RDRS for bulk-load processing.
1. The RDRS bulk load performs an initial target database load by using mainframe source data. Source data can be read directly from the mainframe data store or from a mainframe backup or unload file. The bulk load provides an automatic translation of mainframe data types, like extended binary coded decimal interchange code (EBCDIC)-packed fields. Use the backup or unload data for the best performance instead of a direct read of the mainframe database. You shouldn't read the database directly because moving unload or backup data to the requisite RDRS Azure VM and using native database loaders minimizes network input/output (I/O) and reduces load time.

### Components

The solution uses the following components.

#### Networking and identity components

- [Azure ExpressRoute](https://azure.microsoft.com/products/expressroute/): ExpressRoute lets you extend your on-premises networks into the Microsoft Cloud over a private connection that's handled by a connectivity provider. You can use ExpressRoute to establish connections to cloud services, like Microsoft Azure and Microsoft 365.
- [Azure VPN Gateway](https://azure.microsoft.com/products/vpn-gateway/): A VPN gateway is a specific type of virtual network gateway that sends encrypted traffic between an Azure virtual network and an on-premises location over the public internet.
- [Microsoft Entra ID](https://www.microsoft.com/security/business/identity-access/microsoft-entra-id): Microsoft Entra ID is an identity and access management service that you can synchronize with an on-premises directory.

#### Application components

- [Logic Apps](https://azure.microsoft.com/products/logic-apps/): Logic Apps helps create and run automated recurring tasks and processes on a schedule. You can call services inside and outside of Azure, like HTTP or HTTPS endpoints, post messages to Azure services like Azure Storage and Azure Service Bus, or upload files to a file share.
- [Azure Functions](https://azure.microsoft.com/products/functions/): Azure Functions lets you run small pieces of code, called functions, without worrying about application infrastructure. When you use Functions, the cloud infrastructure provides the up-to-date servers that you need to keep your application running at scale.
- [Azure Virtual Machines](https://azure.microsoft.com/products/virtual-machines/): Azure VMs are on-demand, scalable computing resources. An Azure VM provides the flexibility of virtualization and eliminates the maintenance demands of physical hardware. Azure VMs operate on both Windows and Linux systems.

#### Storage components

- [Storage](https://azure.microsoft.com/products/storage-actions/): Storage offers unmanaged storage solutions like Azure Blob Storage, Azure Table Storage, Azure Queue Storage, and Azure Files. Azure Files is especially useful for re-engineered mainframe solutions and provides an effective add-on with managed SQL storage.
- [Azure SQL](https://azure.microsoft.com/products/azure-sql/): Azure SQL is a fully managed platform as a service (PaaS) for SQL Server from Azure. Relational data can be migrated and used efficiently with other Azure components, such as Azure SQL Managed Instance, Azure SQL VMs, Azure Database for PostgreSQL, Azure Database for MariaDB, and Azure Database for MySQL.
- [Azure Cosmos DB](https://azure.microsoft.com/products/cosmos-db/): Azure Cosmos DB is a no-SQL offering that you can use to migrate non-tabular data off of the mainframe.

#### Monitoring components

- [Azure Monitor](https://azure.microsoft.com/products/monitor/): Azure Monitor delivers a comprehensive solution for collecting, analyzing, and acting on telemetry from cloud and on-premises environments.
- [Application Insights](/azure/azure-monitor/app/app-insights-overview): Application Insights analyzes and presents application telemetry.
- [Azure Monitor Logs](/azure/azure-monitor/logs/data-platform-logs): Azure Monitor Logs is a feature of Monitor that collects and organizes log and performance data from monitored resources. You can consolidate data from multiple sources, like platform logs from Azure services, log and performance data from VM agents, and usage and performance data from applications, into a single workspace to be analyzed together by using a sophisticated query language capable of quickly analyzing millions of records.
- [Log Analytics](/azure/azure-monitor/log-query/log-query-overview): Log Analytics is a tool in the Azure portal. You can use log queries to get insights from the data collected in Azure Monitor Logs. Log Analytics uses a powerful query language so you can join data from multiple tables, aggregate large data sets, and perform complex operations with minimal code.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview). Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the cost of implementing this solution.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Set up RDRS OPM on Azure VMs that are deployed in separate availability zones to provide high availability. In case of failures, a secondary RDRS OPM is activated and the secondary RDRS OPM communicates its IP address to RDRS Mainframe Manager. The mainframe then communicates with the new RDRS OPM that continues to process at its next logical restart point by using a combination of logical unit of work (LUW) and restart files.
- Design Azure database services to support zone redundancy so that they can fail over to a secondary node if there's an outage or a planned maintenance window.
- Use Azure Monitor Logs and Application Insights to monitor the health of an Azure resource. You can set alerts for proactive management.

### Scalability

- Set up RDRS scaling for CDC processing by running multiple parallel replication streams. First analyze the files included in logical transactions. These files must be processed together in sequence. The RDRS CDC process ensures the integrity of each logical transaction. For instance, sets of tables that don't participate in common transactions might be divided into parallel tasks by creating multiple processing scripts.
- RDRS can run parallel concurrent bulk-load processing simultaneously on a single Azure VM or on multiple Azure VMs, which provides horizontal scalability. Perform fast bulk load operations for large tables by splitting the process into multiple tasks, either by using arbitrary intervals or row filtering. Row filtering can use a key, partition key, date, and other filters.
- The SQL Database serverless compute tier provides an automatic scaling option based on the workload. Other Azure databases can be scaled up and scaled down by using automation to meet the workload demands.
- For more information, see [Autoscaling best practices in Azure](/azure/architecture/best-practices/auto-scaling).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Control authentication and access for RDRS by using Microsoft Entra ID.
- Encrypt data transfers between RDRS products (mainframe to Azure) by using Transport Layer Security (TLS).
- Use ExpressRoute or a site-to-site VPN for a private and efficient connection to Azure from an on-premises environment.
- Authenticate Azure resources by using Microsoft Entra ID and manage permissions with role-based access control (RBAC).
- Use the database services in Azure to support various security options like data encryption at rest (TDE), data encryption in transit (TLS), and data encryption while processing, so your data is always encrypted.
- For guidelines about how to design secure solutions, see [Azure security documentation](/azure/security).
- To find out your security baseline, see [Security baselines for Azure](/security/benchmark/azure/security-baselines-overview).

## Scenario details

Mainframes are servers that process a large number of transactions. Mainframe applications produce and consume large amounts of data every day. Public clouds provide elasticity, cost optimization, ease of use, and easy integration. Many x86 and mainframe applications are moving to the cloud, so organizations must have a well-designed mainframe-to-cloud data integration and migration strategy.

This scenario integrates an IBM Z (mainframe) data tier with the Azure cloud data platform by using [RDRS](https://www.rocketsoftware.com/products/rocket-data-replicate-and-sync) provided by [Rocket Software](https://www.rocketsoftware.com/news/rocket-software-acquires-bos-simplify-mainframe-modernization-and-accelerate-hybrid-cloud).

### Potential use cases

This solution is ideal for large-scale data migrations to the Azure data platform. Consider this scenario for the following use cases:

- **Full migration of a mainframe data tier**: In this use case, a customer wants to move all their Db2, IMS, IDMS, files, and other data from a mainframe to the Azure data platform.
- **Coexistence of mainframe and Azure-based applications**: In this use case, a customer requires support for a bidirectional synchronization between a mainframe and the Azure data platform.
- **Archival**: In this use case, a customer wants to store data for audit and compliance purposes but doesn't want to access this data frequently. Storage provides a low-cost solution to store archive data.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Sandip Khandelwal](https://www.linkedin.com/in/sandip-khandelwal-64326a7/) | Senior Engineering Architect

Other contributors:

- [Liz Casey](https://www.linkedin.com/in/elizabethhlizfloriocasey) | Senior Content Developer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Training: Architect a data platform in Azure](/training/paths/architect-data-platform/)
- Contact the [Azure Data Engineering Team](mailto:datasqlninja@microsoft.com).
- [Azure database migration guides](https://datamigration.microsoft.com/)
- [Training: Design a SQL Server migration strategy](/training/modules/introduction-data-platform-modernization/)
- [Migration guide: SQL Server to Azure SQL Database](/training/modules/design-your-migration-to-azure/)

## Related resources

- [Modernize mainframe and midrange data](modernize-mainframe-data-to-azure.yml)
- [Replicate and synch mainframe data in Azure](../../reference-architectures/migration/sync-mainframe-data-with-azure.yml)
