Rocket® Data Replicate and Sync (RDRS), formerly tcVISION, is a data replication solution developed by Rocket Software. RDRS provides an IBM mainframe integration solution for mainframe data replication, data synchronization, data migration, and change data capture (CDC) for several Azure data platform services.

*Rocket® Data Replicate and Sync is a trademark of its company. No endorsement is implied by the use of this mark.*

## Architecture

:::image type="complex" border="false" source="./media/mainframe-realtime-batch-data-replication-azure-rdrs.svg" alt-text="Architecture diagram of the dataflow that shows how to migrate a mainframe to the Azure data platform." lightbox="./media/mainframe-realtime-batch-data-replication-azure-rdrs.svg":::
   A diagram that shows the Real-time Data Replication Solution process for replicating data from an enterprise mainframe datacenter to Microsoft Azure. The diagram is divided into two main sections: the Enterprise mainframe datacenter on the left and Microsoft Azure on the right. On the left, the Enterprise Mainframe Datacenter section includes various databases such as IBM Db2, IMS DB, Adabas, CA Datacom, and CA IDMS. There are solid arrows that point from these databases to the capture agent and apply agent, which are part of the started tasks STCs created on the mainframe. On the right, the Microsoft Azure section includes the open platform manager. There are solid arrows that point from the open platform manager to various Azure data services. Data is consumed by platforms like Power BI, Azure services, or custom applications. There are solid arrows that point from the Azure data platform targets to these platforms, which indicates the flow of data. Also, there is direct streaming support with solid arrows that show data being streamed into Azure Event Hubs or Kafka for further processing by Azure Logic Apps or custom solutions in VMs. RDRS can also reverse synchronize changes from an Azure database platform back to the mainframe tier. Dotted arrows indicate this reverse flow. Mainframe database backup/unload files are copied to an Azure VM for bulk-load processing of initial target database loads by using translated mainframe source data types.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/mainframe-realtime-batch-data-replication-azure-rdrs.vsdx) of this architecture.*

### Dataflow

The following dataflow corresponds to the previous diagram:

1. The RDRS data replication solution supports CDC from many mainframe-based databases, including IBM Db2, IBM Information Management System (IMS) DB, Adabas for Software AG, CA Datacom, and Computer Associates Integrated Data Management System (CA IDMS). RDRS provides log-based CDC agents to capture the change data on the record level. This log-based CDC has a minimal impact on production source databases.

1. RDRS supports CDC from Virtual Storage Access Method files.

1. A task starts on the mainframe. Started tasks, or STCs, are created on the mainframe as part of RDRS software installation. Two crucial STCs are:

   - The capture agent, which captures changed data from the source.

   - The apply agent, which uses database management system (DBMS)-specific APIs to efficiently write changed data to the target.

   > [!NOTE]
   > For Db2 z/OS, RDRS also provides an agentless CDC solution via a Db2 user-defined type (UDT) that doesn't need STCs.

1. The open platform manager (OPM) serves as a replication server. This server contains utilities for automatic data mapping to generate metadata for sources and targets. It also contains the rule set to extract data from the source. The server transforms and processes the data for the target systems and writes the data into the targets. You can install this component on Linux, Unix, and Windows (LUW) operating systems.

1. The RDRS apply agent uses DBMS-specific APIs. These APIs efficiently implement real-time data changes in combination with CDC technology. The changes are applied from the source to the target Azure data services, which are the database and files.

1. RDRS supports direct streaming of the changed data into Azure Event Hubs or Kafka. Then Azure Logic Apps, a function, or a custom solution in the virtual machine (VM) processes these events.

1. The Azure data platform targets that RDRS supports include Azure SQL Database, Azure Database for PostgreSQL, Azure Database for MySQL, Azure Cosmos DB, and Azure Data Lake Storage.

1. Data that lands in the Azure data platform is consumed by Azure services or other platforms that are permitted to see it. These platforms include Power BI, Azure services, or custom applications.

1. RDRS can reverse synchronize capture changes from an Azure database platform such as SQL Database, Azure Database for MySQL, Azure Database for PostgreSQL, or Data Lake Storage. RDRS can then write those changes back to the mainframe data tier.

1. The mainframe database backup and unload files are copied to an Azure VM by using RDRS for bulk-load processing.

1. The RDRS bulk load performs an initial target database load by using mainframe source data. The source data can be read either directly from the mainframe data store or from a mainframe backup or unload file. The bulk load process automatically translates mainframe data types, such as extended binary coded decimal interchange code-packed fields. For optimal performance, use backup or unload data instead of reading the mainframe database directly. Avoid direct reads because moving unload or backup data to the requisite RDRS Azure VM and using native database loaders minimizes network input/output and reduces load times.

### Change data replication from Db2 z/OS to a Microsoft Fabric native SQL database by using RDRS

The following architecture provides an overview of how data is replicated from Db2 z/OS to a Fabric native SQL database in near real time.

:::image type="complex" border="false" source="./media/change-data-capture-mainframe-data-with-azure.svg" alt-text="Diagram that shows both the full data replication and change data replication processes from Db2 z/OS to a Fabric native SQL database by using RDRS." lightbox="./media/change-data-capture-mainframe-data-with-azure.svg":::
   There are two main boxes in the image. The first main box is labeled Customer datacenter. Inside this box are three smaller boxes. The first box is labeled Database management system and contains an icon that represents relational databases. A double-sided arrow labeled ImageCopy or Direct Select points from this icon to a box inside the Microsoft Azure box. A dotted arrow also points from this icon to a box labeled IBM z/OS Work Load Manager. Inside the box labeled IBM z/OS Work Load Manager is another box that reads Db2 UDT process to read Db2 logs. The second main box is labeled Microsoft Azure Components. Inside this box, there are four smaller boxes. There are also arrows that indicate relationships between the boxes and several icons. One box has text that reads the RDRS open platform manager and an icon that represents a LUW VM. Inside this box is a box labeled Capture and apply agent. One solid arrow labeled Data insert and one dotted arrow labeled DML points to a box labeled Microsoft Fabric. A third dotted arrow labeled JSON points from this box to an icon that represents Event Hubs, then to an icon with text that reads Logic Apps, Azure Functions, or a VM-based solution, and finally to the Microsoft Fabric box. A smaller box labeled RDRS dashboard contains an icon that represents the LUW VM and text that reads Metadata, transformation rules, process definitions. A dotted arrow points from this box to the RDRS open platform manager box. The box labeled Microsoft Fabric contains an icon that represents a Microsoft Fabric native SQL database. Three solid arrows originate from one point on this box and point to icons that represent Power BI, Client apps, and Azure services.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/change-data-capture-mainframe-data-with-azure.vsdx) of this architecture.*

#### Initial data load

1. Db2 installed on an IBM Mainframe in the customer's datacenter serves as the source of data for replication to the Azure cloud.

1. To create a full copy, the RDRS capture agent fetches Db2 data by performing SELECT queries on the source Db2 database. If the data size is large, an image copy backup of the data can be sent from the mainframe to the Capture LUW VM in binary format.

1. The OPM serves as a replication server. This server contains utilities for automatic data mapping to generate metadata for sources and targets. It contains the rule set for extracting the data from the source. The server transforms and processes the data for the target systems and writes the data into the targets. You can install this component in LUW operating systems.

1. The RDRS capture and apply agent receives data from Db2, either as the output of SELECT queries or an image copy. After the RDRS apply agent performs the configured transformations, it writes the data to the target Fabric native SQL database.

1. The RDRS apply agent uses the Microsoft ODBC Driver with Microsoft Entra ID authentication for Azure SQL to efficiently write data to the target Fabric native SQL database.

1. Data is ingested into the Fabric native SQL database.

1. After data lands in the Fabric native SQL database, Azure services or other authorized entities consume it, such as Fabric Analytics, Power BI, or custom applications.

#### CDC

A. Db2 installed on an IBM Mainframe in the customer datacenter serves as the source of data for replication to the Azure cloud. RDRS provides the capability to retrieve log-based change data from Db2.

B. RDRS defines the Db2 UDT process to read Db2 logs. The UDT runs in the IBM Workload Manager environment and Db2 DBMS manages it. The UDT reads log data and stores this data in memory for transmission.

C. The OPM serves as a replication server, equipped with utilities for automatic data mapping to generate metadata for sources and targets. It includes rule sets for extracting data from the source, transforms and processes the data for target systems, and writes it to the targets. You can install this component on LUW operating systems. The RDRS capture and apply agent receives data from the UDT process. After the apply agent configures transformations, it writes the data to the target Fabric SQL database.

D. The RDRS dashboard interface enables the administration, operation, control, and monitoring of data exchange processes. The RDRS command-line utilities help automate data exchange processes and manage the unattended operations of the data synchronization process.

E. The RDRS apply agent uses the Microsoft ODBC Driver with Microsoft Entra ID authentication for Azure SQL to perform data manipulation language queries on the target Fabric native SQL database.

F. After data lands in the Fabric native SQL database, Azure services or other authorized entities consume it, including Fabric Analytics, Power BI, or custom applications.

G. RDRS also provides capabilities to write captured data as JSON to Event Hubs or Kafka.

H. Event Hubs serves as a storage platform for CDC data messages.

I. Logic Apps, Azure Functions, or an infrastructure as a service-based custom logic solution in an Azure VM can consume messages from Event Hubs to perform custom processing.

### Components

This solution uses the following components.

#### Networking and identity components

This architecture refers to the following networking services that you can use individually or in combination for enhanced security.

- [An Azure VPN gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) is a specific type of virtual network gateway that sends encrypted traffic between an Azure virtual network and an on-premises location over the public internet. In this architecture, Azure VPN Gateway provides an alternative connectivity option to Azure ExpressRoute for secure communication between the mainframe and Azure.

- [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) is a service that extends your on-premises networks into the Microsoft Cloud over a private connection that a connectivity provider handles. You can use ExpressRoute to establish highly secure and reliable connections to cloud services such as Microsoft Azure and Microsoft 365. In this architecture, ExpressRoute provides a private, secure connection for data replication between the mainframe environment and Azure services.

- [Microsoft Entra ID](/entra/fundamentals/whatis) is an identity and access management service that you can synchronize with an on-premises directory. In this architecture, Microsoft Entra ID provides authentication and access control for RDRS and Azure resources, including ODBC Driver authentication for Azure SQL.

#### Compute components

- [Azure Functions](/azure/well-architected/service-guides/azure-functions-security) is a cloud service that you can use to run small pieces of code, known as functions, without the need to manage or configure the underlying application infrastructure. You can use Azure Functions to automate tasks, process data, integrate systems, and build scalable applications. The cloud infrastructure provides the up-to-date servers that you need to keep your application running at scale. In this architecture, Azure Functions can consume messages from Event Hubs to perform custom processing of change data.

- [Azure VMs](/azure/well-architected/service-guides/virtual-machines) are on-demand, scalable computing resources. An Azure VM provides the flexibility of virtualization and eliminates the maintenance demands of physical hardware. Azure VMs operate on Windows and Linux systems. In this architecture, Azure VMs host the RDRS OPM and can run custom solutions for processing Event Hubs messages or bulk-load processing.

- [Logic Apps](/azure/logic-apps/logic-apps-overview) is a cloud service that creates and runs automated recurring tasks and processes on a schedule. You can call services inside and outside of Azure, like HTTP or HTTPS endpoints, post messages to Azure services like Azure Storage and Azure Service Bus, or upload files to a file share. In this architecture, Logic Apps can process events from Event Hubs to perform custom processing of CDC data.

#### Storage and database components

This architecture discusses the data migration to scalable, more secure cloud storage and managed databases for flexible, intelligent data management in Azure.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a fully managed NoSQL database service that provides global distribution and elastic scalability. In this architecture, Azure Cosmos DB serves as a target platform for nonrelational mainframe data sources.

- [Azure SQL](/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview) is a family of fully managed services based on SQL Server technology. You can migrate relational data and use it efficiently with other Azure components, including Azure SQL Managed Instance, SQL Database, and SQL Server on Azure VMs, along with integration options like Azure Database for PostgreSQL and Azure Database for MySQL. In this architecture, Azure SQL serves as one of the target platforms for mainframe data replication and supports both real-time CDC and bulk-load operations.

- [Azure Storage](/azure/storage/common/storage-introduction) is a cloud storage service that provides managed storage solutions like Azure Blob Storage, Azure Table Storage, Azure Queue Storage, and Azure Files. Azure Files is especially useful for reengineered mainframe solutions and provides an effective add-on with managed SQL storage. In this architecture, Storage services store backup files and provide storage for mainframe data during the replication process.

- [The SQL database in Fabric](/fabric/database/sql/overview) is the primary platform that supports online transaction processing workloads and simplifies setup and management. It has a system that automatically replicates data into OneLake in near real time, which makes it ideal for analytics tasks. Integration with development frameworks and analytics tools helps ensure compatibility and flexibility for various applications. The SQL database in Fabric lets you run queries the same way as SQL Database and includes a web-based editor that you can access through the Fabric portal. In this architecture, the SQL database in Fabric serves as a target for real-time data replication from Db2 z/OS with automatic integration into OneLake for analytics.

#### Monitoring components

- [Azure Monitor](/azure/azure-monitor/overview) is a comprehensive monitoring service that delivers a solution for collecting, analyzing, and acting on telemetry from cloud and on-premises environments. In this architecture, Azure Monitor provides monitoring capabilities for the RDRS replication processes and Azure resources.

  - [Application Insights](/azure/well-architected/service-guides/application-insights) is a feature of Azure Monitor that provides application performance monitoring by collecting and analyzing application telemetry. In this architecture, Application Insights provides monitoring and diagnostics for the RDRS components and data replication processes.

  - [Azure Monitor Logs](/azure/azure-monitor/logs/data-platform-logs) is a feature of Azure Monitor that collects and organizes log and performance data from monitored resources. You can consolidate data from multiple sources, like platform logs from Azure services, log and performance data from VM agents, and usage and performance data from applications, into a single workspace to be analyzed together by using a sophisticated query language that can query across millions of records. In this architecture, Azure Monitor Logs consolidates monitoring data from RDRS components and Azure services for analysis.

  - [Log Analytics](/azure/well-architected/service-guides/azure-log-analytics) is a tool in the Azure portal that enables you to use log queries to get insights from the data collected in Azure Monitor Logs. Log Analytics uses a powerful query language so that you can join data from multiple tables, aggregate large data sets, and perform complex operations with minimal code. In this architecture, Log Analytics provides query capabilities for analyzing RDRS operation logs and performance data.

## Scenario details

Mainframes are servers that process a large number of transactions. Mainframe applications produce and consume large amounts of data every day. Public clouds provide elasticity, cost optimization, ease of use, and easy integration. Many x86 and mainframe applications are moving to the cloud, so organizations must have a well-designed mainframe-to-cloud data integration and migration strategy.

This scenario integrates an IBM Z mainframe data tier with the Azure cloud data platform by using [RDRS](https://www.rocketsoftware.com/products/rocket-data-replicate-and-sync) that [Rocket Software](https://www.rocketsoftware.com/news/rocket-software-acquires-bos-simplify-mainframe-modernization-and-accelerate-hybrid-cloud) provides.

### Potential use cases

This solution is ideal for large-scale data migrations to the Azure data platform. Consider this scenario for the following use cases:

- **Full migration of a mainframe data tier:** In this use case, a customer wants to move all their Db2, IMS, IDMS, files, and other data from a mainframe to the Azure data platform.

- **Coexistence of mainframe and Azure-based applications:** In this use case, a customer requires support for a bidirectional synchronization between a mainframe and the Azure data platform.

- **Archival:** In this use case, a customer wants to store data for audit and compliance purposes but doesn't want to access this data frequently. Storage provides a low-cost solution to store archive data.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Set up the RDRS OPM on Azure VMs that are deployed in separate availability zones to provide high availability. If a failure occurs, a secondary RDRS OPM is activated and communicates its IP address to the RDRS mainframe manager. The mainframe then communicates with the new RDRS OPM that continues to process at its next logical restart point by using a combination of logical unit of work and restart files.

- Design Azure database services to support zone redundancy so that they can fail over to a secondary node if there's an outage or a planned maintenance window.

- Use Azure Monitor Logs and Application Insights to monitor the health of an Azure resource. You can set alerts for proactive management.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Control authentication and access for RDRS by using Microsoft Entra ID.

- Encrypt data transfers between RDRS products, like transfers from mainframe to Azure, by using Transport Layer Security (TLS).

- Use ExpressRoute or a site-to-site VPN for a more private and efficient connection to Azure from an on-premises environment.

- Authenticate Azure resources by using Microsoft Entra ID and manage permissions by using role-based access control.

- Use the database services in Azure to support various security options like Transparent Data Encryption for data at rest, TLS for data in transit, and data encryption while processing to help ensure that your data is always encrypted. For more information, see [Azure security documentation](/azure/security) and [Security baselines for Azure](/security/benchmark/azure/security-baselines-overview).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the cost of implementing this solution.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

#### Scalability

- Set up RDRS scaling for CDC processing by running multiple parallel replication streams. First analyze the files included in logical transactions. These files must be processed together in sequence. The RDRS CDC process helps ensure the integrity of each logical transaction. For instance, sets of tables that don't participate in common transactions might be divided into parallel tasks by creating multiple processing scripts.

- RDRS can run parallel concurrent bulk-load processing simultaneously on a single Azure VM or on multiple Azure VMs, which provides horizontal scalability. Perform fast bulk load operations for large tables by splitting the process into multiple tasks, either by using arbitrary intervals or row filtering. Row filtering can use a key, partition key, date, and other filters.

- The SQL Database serverless compute tier provides an automatic scaling option based on the workload. Other Azure databases can be scaled up and scaled down by using automation to meet the workload demands. For more information, see [Autoscaling best practices in Azure](/azure/architecture/best-practices/auto-scaling).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Sandip Khandelwal](https://www.linkedin.com/in/sandip-khandelwal-64326a7/) | Senior Engineering Architect

Other contributors:

- [Liz Casey](https://www.linkedin.com/in/elizabethhlizfloriocasey) | Senior Content Developer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure database migration guides](https://datamigration.microsoft.com/)
- [Migration guide: SQL Server to Azure SQL Database](/training/modules/design-your-migration-to-azure/)
- [Training: Architect a data platform in Azure](/training/paths/architect-data-platform/)
- [Training: Design a SQL Server migration strategy](/training/modules/introduction-data-platform-modernization/)

## Related resources

- [Modernize mainframe and midrange data](modernize-mainframe-data-to-azure.yml)
- [Replicate and sync mainframe data in Azure](../../reference-architectures/migration/sync-mainframe-data-with-azure.yml)
