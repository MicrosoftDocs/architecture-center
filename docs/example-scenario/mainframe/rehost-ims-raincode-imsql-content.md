This architecture describes how to implement an Information Management System (IMS) mainframe application workload on Azure by using Raincode's IMSql. Migrating an IMS database (DB) application to a cloud-native solution is more complex than migrating a relational database application. This article describes how to seamlessly rehost a mainframe IMS workload that has critical IMS features and capabilities to Azure. You don't need to translate or modify your existing application.

## IMS DB/DC workload architecture, before migration

:::image type="content" source="media/pre-migration.svg" alt-text="Diagram that shows the pre-migration IMS DB/DC workload architecture." lightbox="media/pre-migration.svg" border="false":::

_Download a [Visio file](https://arch-center.azureedge.net/rehost-ims-raincode-imsql-ibm-ims-dbdc-zos.vsdx) of this architecture._

### Dataflow

1. Users connect to the mainframe over TCP/IP by using standard mainframe protocols like TN3270 and HTTPS.
1. Transaction managers interact with users and invoke the application to satisfy user requests.
1. In the front end of the application layer, users interact with IMS screens or with web pages.
1. Application code uses the storage capabilities of the IMS DB (hierarchical) back-end data layer.
1. All offline big data operations are performed via batch jobs.
1. Concurrently with transaction processing, other services provide authentication, security, management, monitoring, and reporting. These services interact with all other services in the system.

## IMSql architecture on Azure

:::image type="content" source="media/imsql.svg" alt-text="Diagram that shows the IMSql architecture on Azure." lightbox="media/imsql.svg" border="false":::

_Download a [Visio file](https://arch-center.azureedge.net/rehost-ims-raincode-imsql.vsdx) of this architecture._

### Dataflow

1. IMSql Terminal Server

   Traditionally, the Mainframe z/OS interface is accessed via an IBM in-house terminal or via terminal emulation software. An application that has a geographically dispersed network with thousands of users can connect to the mainframes through any form of terminal. When an IMS Data Communications (DC) application is rehosted on the distributed cloud-based system, you need to centrally host the application and resource and publish them for the remote client devices. You can accomplish these tasks on Azure by using IMSql Terminal Servers.

2. SQL Server Service Broker

   In Mainframe, IMS DC orchestrates the communication layer between the user terminals and the application programs by transmitting and processing messages in a control region. After the rehost, SQL Server Service Broker orchestrates this asynchronous communication layer. Service Broker helps with communication through its message delivery framework and scales out messages to separate processing servers, current users, and their transaction processing.

3. IMSql Processing Server

   The Processing Server runs the Raincode-recompiled code for the IMS programs in .NET Framework or .NET Core. It contains the underlying infrastructure that's needed to enable the recompiled programs to run effectively with the correct functional equivalence. IMSql Processing Server can generate dynamic queries and call SQL stored procedures that are created during the recompilation of DL/I calls.

4. SQL Server as a hierarchical data store

   Data is stored as hierarchical data in IMS. IMSql uses the same model on SQL Server. This model enables IMSql to take advantage of the high performance of relational databases and logically implement the hierarchical segments from IMS. It also enables the system to scale independently with segments. The segment data is stored in raw EBCDIC format, so it doesn't need to be converted for the application. By using SQL platform as a service (PaaS), IMSql can take advantage of the underlying HA/DR capabilities that are provided by Azure.

5. DL/I call API

   - The IMSql API ensures that the COBOL IMS DL/I calls are translated to equivalent SQL queries, fetches the data, and returns it back to the application program in the expected format.
   - IMSql also tracks the Program position on the Table record to perform create, read, update, and delete (CRUD) operations, like the hierarchical DB.
   - IMSql can create SQL stored procedures during compilation to respond to performance-intensive DL/I calls.

6. Raincode JCL

   Raincode job control language (JCL) is an interpreter that's compatible with z/OS JCL. The Raincode JCL interpreter makes the transition from the intricate business logic embedded in JCL to the Azure and .NET Core platforms as smooth as possible. Raincode JCL is designed to run code compiled by the Raincode COBOL, PL/I, and ASM370 compilers. It can easily run steps written in virtually any language. It can be configured and fine-tuned with user-written code, so you can adapt it to your own needs for batch scheduling.

7. IMSql data view

   - IMSql defines relational SQL views based on copybooks (record layouts), so that the IMS segments can be accessed via plain SQL statements by any Azure service and by new applications.
   - IMSql views are also writable, so modern applications can interact with IMS in both ways via SQL Server.

## Data migration via IMSql

:::image type="content" source="media/data-migration.svg" alt-text="Diagram that shows the data migration via IMSql." lightbox="media/data-migration.svg" border="false":::

_Download a [Visio file](https://arch-center.azureedge.net/rehost-ims-raincode-imsql-data-migration.vsdx) of this architecture._

### Database object migration

- The original IMS DB database description (DBD) is extracted and transferred from Mainframe. IMSql uses the DBD information to produce SQL scripts for generating a target database and tables in Azure SQL.
- Each segment in an IMS DBD is translated as a table on Azure.
- The tables consist of a key field, search fields, and the complete IMS segment data as it's represented in EBCDIC.
- The IMS segment tree structure is retained with the primary and foreign key relationship in Azure SQL tables.

### Initial data load

- The data from IMS DB is extracted via a mainframe job and commonly available download utilities like DFSRRC00 and DFSURGL0.
- You can transfer the extracted binary files to Azure by using Azure Data Factory connectors like FTP and SFTP and a Java-based solution that runs on Unix Subsystem Services (USS).
- IMSql has a built-in load utility for completing the initial data loads. This tool uses the SQL Server bulk copy program (bcp) utility. It ensures bcp execution and the required referential integrity between the tables to match the expected hierarchical structure.
- This migration addresses a one-time data load from IMS DB, not co-existence and associated data synchronization.

### Dataflow

1. The mainframe non-relational datastore (IMS DB) has two components: the DBD and the actual segment data.
1. IBM utilities extract and unload the IMS DB information.
1. The DBD file and corresponding binary data files are generated separately.
1. Data ingestion:
   1. The Data Factory FTP connector copies Mainframe IMS datasets to Azure data storage.
   1. Mainframe IMS data files are copied to Azure Blob Storage via SFTP.
   1. Mainframe JCL is used to run a custom Java solution that moves data between the mainframe system and SFTP Azure Blob Storage.
1. By using the DBD file, IMSql creates the target DB and tables, with necessary referential integrity.
1. After data objects are created, IMSql loads the data to the corresponding table in sequential order.
1. All migrated IMS data is hosted in Azure SQL Managed Instance.
1. The application database consists of the raw segment data for processing IMS online and batch processing.
1. The IMS read/write views consist of segment data that's expanded based on the copybook layout.

### Components

- [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps) enables you to quickly build powerful integration solutions. Mainframe users are familiar with 3270 terminals and on-premises connectivity. They can use the Logic Apps [IBM 3270 connector](/azure/connectors/connectors-run-3270-apps-ibm-mainframe-create-api-3270) to access and run IBM mainframe apps. In the migrated system, they interact with Azure applications via the public internet or a private connection that's implemented via Azure ExpressRoute. [Azure Active Directory (Azure AD)](https://azure.microsoft.com/services/active-directory) provides authentication.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is the fundamental building block for your private network on Azure. Virtual Network enables many types of Azure resources, like Azure virtual machines (VMs), to communicate with each other, the internet, and on-premises networks, all with improved security. Virtual Network is like a traditional network that you operate in your own datacenter, but it brings more of the benefits of the Azure infrastructure, like scale, availability, and isolation.
- [ExpressRoute](https://azure.microsoft.com/services/expressroute) enables you to extend your on-premises networks into the Microsoft Cloud over a private connection that's facilitated by a connectivity provider. You can use ExpressRoute to establish connections to Microsoft Cloud services like Azure and Office 365.
- [Azure Virtual Machine Scale Sets](https://azure.microsoft.com/services/virtual-machine-scale-sets) provides automated and load balanced VM scaling that simplifies the management of your applications and increases availability.
- [SQL Managed Instance](https://azure.microsoft.com/products/azure-sql/managed-instance), part of the Azure SQL service portfolio, is a managed, highly secure, always up-to-date SQL instance in the cloud.
- [Azure AD](https://azure.microsoft.com/services/active-directory) is a cloud-based enterprise identity and access management service. Azure AD single sign-on and multifactor authentication help users sign in and access resources while helping to protect against cybersecurity attacks.

### Alternatives

- You can use SQL Server in an Azure virtual machine as an alternative to SQL Managed Instance. We recommend SQL Managed Instance in this architecture because of benefits like high availability, seamless integration with various Azure services, and management of underlying security patches and maintenance.
- You can use an Azure single-VM architecture as an alternative to Virtual Machine Scale Sets. You might want to use single VMs for workloads that have constant load and performance demands and no need for scaling. This architecture uses Virtual Machine Scale Sets to handle typical IMS workloads.

## Scenario details

Mainframe OLTP systems can process millions of transactions for vast numbers of users. IBM IMS is a robust classic mainframe transaction manager used by major companies for online transaction processing. It has two main components: the IMS DC component and the underlying hierarchical DBMS IMS DB component.

IMSql provides a way to host IMS-based workloads on Azure or on-premises distributed implementations that are based on SQL Server. IMSql provides a holistic solution for running an IMS workload, including the app, data, and middleware components. It can ingest the hierarchical (IMS DB) data structure to a relational data model in SQL Server, SQL Server on Azure Virtual Machines, and SQL Managed Instance. It has built-in APIs for IMS application program DL/I calls and extends the data layer beyond the hierarchical workload to cloud-native apps that are used for relational data.

This solution provides the following benefits:

- Modernize infrastructure and reduce the high costs, limitations, and rigidity associated with monolithic mainframe IMS workloads.
- Reduce technical debt by implementing cloud-native solutions and DevOps.
- Provide IMS DB data to non-mainframe and cloud-based applications, including AI and analytics applications.

### Potential use cases

- Banking, finance, insurance, government, and retail industries that use Mainframe IMS. Many of these organizations run their primary OLTP and batch applications on IMS DB/DC.
- IBM zSeries mainframe customers who need to migrate mission-critical applications while maintaining continuity with other on-premises applications and avoiding the side effects of a complete redevelopment.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- This OLTP architecture can be deployed in multiple regions and can incorporate a geo-replication data layer.
- The Azure database services support zone redundancy and can fail over to a secondary node during outages or to enable maintenance activities.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- ExpressRoute provides a private and efficient connection to Azure from on-premises.
- You can use Azure AD to authenticate Azure resources. You can use role-based access control (RBAC) to manage permissions.
- This solution uses an Azure network security group to manage traffic to and from Azure resources. For more information, see [Network security groups](/azure/virtual-network/network-security-groups-overview).
- These security options are available in Azure database services:
  - Data encryption at rest
  - Dynamic data masking
  - Always Encrypted data

For general guidance on designing highly secure data solutions, see [Azure security recommendations](/sql/relational-databases/security/security-center-for-sql-server-database-engine-and-azure-sql-database?view=sql-server-ver16).

### Cost optimization

Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- Virtual Machine Scale Sets optimizes costs by minimizing the number of unnecessary hardware instances that run your application when demand is low.
- SQL Managed Instance provides various pricing tiers, like general purpose and business critical, to optimize costs based on usage and business criticality.
- For compute, use [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) and [Azure savings plan for compute](https://azure.microsoft.com/pricing/offers/savings-plan-compute/#benefits-and-features) with a one-year or three-year contract and receive significant savings off pay-as-you-go prices. In many cases, you can further reduce your costs by implementing reserved-instance size flexibility.
- [Azure Hybrid Benefit](https://azure.microsoft.com/pricing/hybrid-benefit) is a licensing benefit that can help you significantly reduce the costs of running your workloads in the cloud. It works by letting you use your on-premises Software Assurance-enabled Windows Server and SQL Server licenses on Azure.

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the cost of implementing this solution. Here's an [estimate that's based on the components of this solution, at a reasonable scale](https://azure.com/e/f5d10c617bfa410cb7566ee7f30a8e2f).

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

- Virtual Machine Scale Sets ensures that enough VMs are available to meet mission-critical online and batch processing needs.
- Azure Blob Storage is a scalable system for storing backups, archival data, secondary data files, and other unstructured digital objects.
- [Database Engine Tuning Advisor](/sql/relational-databases/performance/database-engine-tuning-advisor?view=sql-server-ver16) analyzes databases and makes recommendations that you can use to optimize query performance. You can use Database Engine Tuning Advisor to select and create an optimal set of indexes, indexed views, or table partitions.
- [Scalability](/azure/azure-sql/database/scale-resources?view=azuresql) is one of the most important characteristics of PaaS. It enables you to dynamically add resources to your service when they're needed. You can use Azure SQL Database to easily change the resources (CPU power, memory, I/O throughput, and storage) that are allocated to your databases. You can use SQL Managed Instance to dynamically add resources to your database with minimal downtime.
- [In-Memory OLTP](/sql/relational-databases/in-memory-oltp/overview-and-usage-scenarios?view=sql-server-ver16) is a technology available in SQL Server and SQL Database for optimizing the performance of transaction processing, data ingestion, data load, and transient data scenarios.

## Contributors

_This article is maintained by Microsoft. It was originally written by the following contributors._

Principal authors:

- [Nithish Aruldoss](https://www.linkedin.com/in/nithish-aruldoss-b4035b2b) | Engineering Architect
- [Amethyst Solomon](https://www.linkedin.com/in/amethyst-solomon) | Senior Engineering Architect

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer

_To see non-public LinkedIn profiles, sign in to LinkedIn._

## Next steps

- [Mainframe to Azure Data Factory using FTP Connector](https://techcommunity.microsoft.com/t5/modernization-best-practices-and/copy-files-from-mainframe-to-azure-data-platform-using-adf-ftp/ba-p/3042555)
- [Mainframe to Azure Data Platform using SFTP](https://techcommunity.microsoft.com/t5/modernization-best-practices-and/mainframe-files-transfer-to-azure-data-platform-using-sftp/ba-p/3302194)
- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [What is Azure ExpressRoute?](/azure/expressroute/expressroute-introduction)

For more information, contact [Azure Data Engineering - Mainframe Modernization](mailto:mainframedatamod@microsoft.com).

## Related resources

See the companion architecture:

- [Rehost IMS workloads to virtual machines by using IMSql](imsql-rehost-ims.yml)

More related resources:

- [General mainframe refactor to Azure](general-mainframe-refactor.yml)
- [Mainframe access to Azure databases](../../solution-ideas/articles/mainframe-access-azure-databases.yml)
- [Re-engineer mainframe batch applications on Azure](../../example-scenario/mainframe/reengineer-mainframe-batch-apps-azure.yml)
- [Rehost a general mainframe on Azure](../../example-scenario/mainframe/mainframe-rehost-architecture-azure.yml)
