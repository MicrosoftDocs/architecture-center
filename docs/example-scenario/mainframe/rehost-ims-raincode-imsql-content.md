This architecture describes how to implement an Information Management System (IMS) mainframe application workload on Azure by using Raincode's IMSql. Migrating an IMS database (DB) application to a cloud-native solution is more complex than migrating a relational DB application. This article describes how to seamlessly rehost a mainframe IMS workload that has critical IMS features and capabilities to Azure. You don't need to translate or modify your existing application.

## IMS DB/DC workload architecture, before migration

:::image type="complex" source="media/pre-migration.svg" alt-text="Diagram that shows the premigration IMS DB/DC workload architecture." lightbox="media/pre-migration.svg" border="false":::
   The diagram shows the architecture of an IMS DB/DC workload before migration to Azure. The flow begins with an on-premises user accessing communication protocols like HTTPS via a TN3270 terminal or a web interface. A double-sided arrow connects the communication protocols to transaction managers like IMS DC. A box that's labeled front end contains online programs. A double-sided arrow that's labeled DL/I connects the front end to another box that's labeled back end. This box contains IMS data and is connected to the IMS DB data layer. Another double-sided arrow that's labeled DL/I connects the data layer to a box that contains batch jobs. A box that's labeled other services contains services like security and reporting. These services interact with all the parts of the diagram. 
:::image-end:::   

### Dataflow

The following dataflow corresponds to the previous diagram:

1. Users connect to the mainframe over Transmission Control Protocol or Internet Protocol by using standard mainframe protocols like TN3270 and HTTPS.
1. Transaction managers interact with users and invoke the application to satisfy user requests.
1. In the front end of the application layer, users interact with IMS screens or with webpages.
1. Application code uses the storage capabilities of the IMS DB (hierarchical) back-end data layer.
1. All offline big data operations are performed via batch jobs.
1. Along with transaction processing, other services provide authentication, security, management, monitoring, and reporting. These services interact with all other services in the system.

## IMSql architecture on Azure

:::image type="complex" source="media/rehost-ims-raincode-imsql.svg" alt-text="Diagram that shows the IMSql architecture on Azure." lightbox="media/rehost-ims-raincode-imsql.svg" border="false":::
   The diagram shows the IMSql architecture on Azure. On the left, labeled "On-premises," a 3270 terminal emulator connects on-premises users to Azure ExpressRoute, which bridges the on-premises environment with Azure. The right side, labeled "Azure," contains multiple components and services inside of boxes that are connected by arrows. Users from Azure systems access the IMSql terminal server through an Azure Logic Apps (IBM 3270 terminal) interface. A double-sided arrow that's labeled "Service broker" connects the user terminals and the application programs. Arrows connect Virtual Machine Scale Sets to IMS application data that's inside of a box labeled "SQL Managed Instance." This box connects to Microsoft services like Azure Functions and Microsoft Fabric, which read and write IMS data. The IMSql terminal server, Virtual Machine Scale Sets, service broker, IMS application data, and Microsoft services are all inside of a larger box that's labeled "Microsoft Entra ID."
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/rehost-ims-raincode-imsql.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. IMSql terminal server

   Traditionally, on-premises users access the mainframe z/OS interface via an IBM in-house terminal or via terminal emulation software. An application that has a geographically dispersed network with thousands of users can connect to the mainframes through any form of terminal. When an IMS Data Communications (DC) application is rehosted on the distributed cloud-based system, you need to centrally host the application and the resource and publish them for the remote client devices. You can use IMSql terminal servers to host and publish the application and resource on Azure.

1. SQL Server service broker

   In the mainframe, IMS DC orchestrates the communication layer between the user terminals and the application programs by transmitting and processing messages in a control region. After the rehost, the SQL Server service broker orchestrates this asynchronous communication layer. The service broker enables communication through its message delivery framework and scales out messages to separate processing servers, current users, and their transaction processing.

1. IMSql processing server

   The processing server runs the Raincode-recompiled code for the IMS programs in .NET Framework or .NET Core. It contains the underlying infrastructure that lets the recompiled programs run effectively with the correct functional equivalence. The IMSql processing server can generate dynamic queries and call stored procedures in SQL Server that are created during the recompilation of Data Language/One (DL/I) calls.

1. SQL Server as a hierarchical data store

   Data is stored as hierarchical data in IMS. IMSql uses the same model on SQL Server. This model lets IMSql take advantage of the high performance of relational DBs and logically implement the hierarchical segments from IMS. It also lets the system scale independently with segments. The segment data is stored in raw EBCDIC format, so it doesn't need to be converted for the application. By using SQL platform as a service (PaaS), IMSql can take advantage of the underlying high availability and disaster recovery capabilities that Azure provides.

1. DL/I call API

   The IMSql API ensures that the common business-oriented language (COBOL) IMS DL/I calls are translated to equivalent SQL queries. It then fetches the data and returns it to the application program in the expected format. IMSql also tracks the program position on the table record to perform the create, read, update, and delete operations, like the hierarchical DB. IMSql can create stored procedures in SQL Server during compilation to respond to performance-intensive DL/I calls.

1. Raincode JCL

   Raincode job control language (JCL) is an interpreter that's compatible with z/OS JCL. The Raincode JCL interpreter makes the transition from the intricate business logic embedded in JCL to the Azure and .NET Core platforms as smooth as possible. Raincode JCL is designed to run code compiled by the Raincode COBOL, Programming Language One (PL/I), and ASM370 compilers. It can easily run steps written in most languages. You can configure and fine-tune it by implementing user-written code, so you can adapt it to your own needs for batch scheduling.

1. IMSql data view

   IMSql defines relational SQL views based on copybooks, or record layouts, so that the IMS segments can be accessed via plain SQL statements by any Azure service and by new applications. IMSql views are also writable, so modern applications can interact with IMS in both ways via SQL Server.

## Data migration via IMSql

:::image type="complex" source="media/data-migration.svg" alt-text="Diagram that shows the data migration via IMSql." lightbox="media/data-migration.svg" border="false":::
   The diagram shows the data migration process via IMSql. It's divided into two main sections, on-premises and Azure. A dotted, double-sided arrow that represents Azure ExpressRoute connects the two sections. In the on-premises section, a box that's labeled "data store" contains two smaller boxes, one for nonrelational DBs and one for DBD files. An arrow that's labeled "IBM utility" points from the nonrelational DBs to the DBD data files. An arrow from the DBD files passes through an icon for self-hosted integration runtime and to a box in the Azure section that contains Azure Data Factory and FTP. An arrow points from this box to Azure Blob Storage. Another arrow points from Blob Storage to a box that contains the IMSql processing server. Inside this box are two smaller boxes for DB object conversion and data load. Arrows point from these boxes to another box in which a dotted line connects icons for SQL Managed Instance, application DB, and read-write views on IMS data.
:::image-end:::

### DB object migration

- The original IMS DB database description (DBD) is extracted and transferred from the mainframe. IMSql uses the DBD information to produce SQL scripts to generate a target DB and tables in Azure SQL.

- Each segment in an IMS DBD is translated as a table in Azure.

- The tables consist of a key field, search fields, and the complete IMS segment data represented in EBCDIC.

- The IMS segment tree structure is retained with the primary and foreign key relationship in Azure SQL tables.

### Initial data load

- The data from IMS DB is extracted via a mainframe job and commonly available download utilities like DFSRRC00 and DFSURGL0.

- You can transfer the extracted binary files to Azure by using Azure Data Factory connectors like File Transfer Protocol (FTP) and Secure File Transfer Protocol (SFTP) and a Java-based solution that runs on Unix Subsystem Services.

- IMSql has a built-in load utility for completing the initial data loads. This tool uses the SQL Server bulk copy program (bcp) utility. It ensures that bcp runs and that the required referential integrity between the tables matches the expected hierarchical structure.

- This migration addresses a one-time data load from IMS DB. It doesn't address coexistence and associated data synchronization.  

### Dataflow for migration

The following dataflow corresponds to the previous diagram:

1. The mainframe nonrelational data store (IMS DB) has two components: the DBD and the actual segment data.

1. IBM utilities extract and unload the IMS DB information.

1. The DBD file and corresponding binary data files are generated separately.

1. Data ingestion:

   1. The Azure Data Factory FTP connector copies mainframe IMS datasets to Azure data storage.
   1. Mainframe IMS data files are copied to Azure Blob Storage via SFTP.
   1. Mainframe JCL is used to run a custom Java solution that moves data between the mainframe system and SFTP Blob Storage.

1. By using the DBD file, IMSql creates the target DB and tables while keeping the necessary referential integrity.

1. After data objects are created, IMSql loads the data to the corresponding table in sequential order.

1. All migrated IMS data is hosted in Azure SQL Managed Instance.

1. The application DB consists of the raw segment data for processing IMS online and batch processing.

1. The IMS read and write views consist of segment data that expands based on the copybook layout.

### Migrate IMS DB data by using Raincode zBridge

[Raincode zBridge](https://www.raincode.com/zbridge/) facilitates access to mainframe nonrelational data on Azure, including data from IMS/DB segments. This data becomes available in Azure SQL DBs for distributed applications, reporting, and analytical purposes.

IMS segment data files are imported into zBridge with a matching COBOL copybook or PL/I include. The data appears as SQL rows that convert mainframe numeric types to SQL types and convert strings to ASCII if needed. zBridge also supports complex data structures.

### Components

- [Azure Logic Apps](/azure/logic-apps/logic-apps-overview) is a cloud platform where you can quickly build powerful integration solutions. Mainframe users are familiar with 3270 terminals and on-premises connectivity. They can use the Logic Apps [IBM 3270 connector](/azure/connectors/connectors-run-3270-apps-ibm-mainframe-create-api-3270) to access and run IBM mainframe apps. In this architecture, Logic Apps enables mainframe users to interact with migrated Azure applications via the public internet or a private connection implemented via Azure ExpressRoute, with Microsoft Entra ID providing authentication.

- [Azure Virtual Machine Scale Sets](/azure/well-architected/service-guides/virtual-machines) is a compute service that provides automated and load balanced virtual machine (VM) scaling that simplifies application management and increases availability. In this architecture, Virtual Machine Scale Sets ensures that enough VMs are available to meet mission-critical online and batch processing needs for the IMSql workload.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is the fundamental building block for your private network on Azure. Virtual Network enables more secure communication between many types of Azure resources, like Azure VMs, and with the internet and on-premises networks. Virtual Network is like a traditional network that you operate in your own datacenter, but it provides the benefits of Azure infrastructure, like scale, availability, and isolation. In this architecture, Virtual Network provides the secure network foundation for all the IMSql components to communicate effectively.

- [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) is a connectivity service that extends your on-premises networks into the Microsoft Cloud over a private connection that a connectivity provider facilitates. You can use ExpressRoute to establish connections to Microsoft Cloud services like Azure and Microsoft 365. In this architecture, ExpressRoute provides secure, high-bandwidth connectivity between on-premises mainframe environments and the migrated IMS applications that run on Azure.

- [Microsoft Entra ID](/entra/fundamentals/whatis) is a cloud-based enterprise identity and access management service. In this architecture, Microsoft Entra ID provides single sign-on and multifactor authentication to help users sign in and access resources while helping to protect against cybersecurity attacks.

- [SQL Managed Instance](/azure/well-architected/service-guides/azure-sql-managed-instance/reliability) is part of the Azure SQL service portfolio and a managed, more secure, up-to-date SQL instance in the cloud. In this architecture, SQL Managed Instance provides the relational database platform for storing the converted hierarchical IMS DB data structures with high availability and integration with Azure services.

### Alternatives

- You can use SQL Server in an Azure VM as an alternative to SQL Managed Instance. We recommend SQL Managed Instance in this architecture because of benefits like high availability, seamless integration with various Azure services, and management of underlying security patches and maintenance.

- You can use an Azure single-VM architecture as an alternative to Virtual Machine Scale Sets. You might want to use single VMs for workloads that have constant load and performance demands and no need for scaling. This architecture uses Virtual Machine Scale Sets to handle typical IMS workloads.

## Scenario details

Mainframe online transaction processing (OLTP) systems can process millions of transactions for vast numbers of users. IBM IMS is a robust classic mainframe transaction manager that companies use for online transaction processing. It has two main components: the IMS DC component and the underlying hierarchical DBMS IMS DB component.

IMSql provides a way to host IMS-based workloads on Azure or on-premises distributed implementations that are based on SQL Server. IMSql provides a holistic solution for running an IMS workload, including the app, data, and middleware components. It can ingest the hierarchical (IMS DB) data structures to a relational data model in SQL Server, SQL Server on Azure Virtual Machines, and SQL Managed Instance. It has built-in APIs for IMS application program DL/I calls and extends the data layer beyond the hierarchical workload to cloud-native apps that are used for relational data.

This solution provides the following benefits:

- It modernizes infrastructure and reduces the high costs, limitations, and rigidity associated with monolithic mainframe IMS workloads.

- It reduces technical debt by implementing cloud-native solutions and DevOps.

- It sends IMS DB data to cloud-based applications that don't use a mainframe, including AI and analytics applications.

### Potential use cases

This solution might be useful to:

- Banking, finance, insurance, government, and retail industries that use Mainframe IMS. Many of these organizations run their primary OLTP and batch applications on IMS DB/DC.

- IBM zSeries mainframe customers who need to migrate mission-critical applications. These customers want to maintain continuity with other on-premises applications and avoid the effects of a complete redevelopment.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- You can deploy this OLTP architecture in multiple regions and incorporate a geo-replication data layer.

- The Azure DB services support zone redundancy and can fail over to a secondary node during outages or to enable maintenance activities.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- ExpressRoute provides a private and efficient connection to Azure from on-premises.

- You can use Microsoft Entra ID to authenticate Azure resources. You can use role-based access control to manage permissions.

- This solution uses an Azure network security group to manage traffic to and from Azure resources. For more information, see [Network security groups](/azure/virtual-network/network-security-groups-overview).

- These security options are available in Azure DB services:

  - Data encryption at rest
  - Dynamic data masking
  - Always Encrypted data

For general guidance about how to design highly secure data solutions, see [Security for SQL Server Database Engine and Azure SQL Database](/sql/relational-databases/security/security-center-for-sql-server-database-engine-and-azure-sql-database).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Virtual Machine Scale Sets optimizes costs by minimizing the number of unnecessary hardware instances that run your application when demand is low.

- SQL Managed Instance provides various pricing tiers, like general purpose and business critical, to optimize costs based on usage and business criticality.

- [Azure reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) and [Azure savings plan for compute](https://azure.microsoft.com/pricing/offers/savings-plan-compute/#benefits-and-features) with a one-year or three-year contract provide significant savings compared to pay-as-you-go prices. In many cases, you can further reduce your costs by implementing reserved-instance size flexibility.

- [Azure Hybrid Benefit](https://azure.microsoft.com/pricing/hybrid-benefit) is a licensing benefit that can help you significantly reduce the costs of running your workloads in the cloud. It works by letting you use your on-premises Software Assurance-enabled Windows Server and SQL Server licenses on Azure.

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the cost of implementing this solution. Here's an [estimate based on the components of this solution, at a reasonable scale](https://azure.com/e/f5d10c617bfa410cb7566ee7f30a8e2f).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- Virtual Machine Scale Sets ensures that enough VMs are available to meet mission-critical online and batch processing needs.

- Blob Storage is a scalable system for storing backups, archival data, secondary data files, and other unstructured digital objects.

- [Database Engine Tuning Advisor](/sql/relational-databases/performance/database-engine-tuning-advisor) analyzes DBs and makes recommendations that you can use to optimize query performance. You can use Database Engine Tuning Advisor to select and create an optimal set of indexes, indexed views, or table partitions.

- [Scalability](/azure/azure-sql/database/scale-resources) is one of the most important characteristics of PaaS. It lets you dynamically add resources to your service when you need them. You can use SQL Database to easily change the resources, such as CPU power, memory, input/output throughput, and storage, that are allocated to your DBs. You can use SQL Managed Instance to dynamically add resources to your DB with minimal downtime.

- [In-Memory OLTP](/sql/relational-databases/in-memory-oltp/overview-and-usage-scenarios) is a technology available in SQL Server and SQL Database for optimizing the performance of transaction processing, data ingestion, data load, and transient data scenarios.  

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Nithish Aruldoss](https://www.linkedin.com/in/nithish-aruldoss-b4035b2b) | Engineering Architect
- [Amethyst Solomon](https://www.linkedin.com/in/amethyst-solomon) | Senior Engineering Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Copy files from the mainframe to Azure Data Factory by using the FTP connector](https://techcommunity.microsoft.com/t5/modernization-best-practices-and/copy-files-from-mainframe-to-azure-data-platform-using-adf-ftp/ba-p/3042555) 
- [Transfer mainframe files to Blob Storage by using SFTP](https://techcommunity.microsoft.com/t5/modernization-best-practices-and/mainframe-files-transfer-to-azure-data-platform-using-sftp/ba-p/3302194)
- [What is Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [What is ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [Microsoft Fabric documentation](/fabric)

For more information, contact [Azure Data Engineering - Mainframe Modernization](mailto:mainframedatamod@microsoft.com).

## Related resources

See the companion architecture:

- [Rehost IMS workloads to VMs by using IMSql](imsql-rehost-ims.yml)

More related resources: 

- [General mainframe refactor to Azure](general-mainframe-refactor.yml)
- [Re-engineer mainframe batch applications on Azure](../../example-scenario/mainframe/reengineer-mainframe-batch-apps-azure.yml)
- [Rehost a general mainframe on Azure](../../example-scenario/mainframe/mainframe-rehost-architecture-azure.yml)
