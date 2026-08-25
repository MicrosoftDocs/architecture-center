[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This architecture describes how to implement an Information Management System (IMS) mainframe application workload on Azure by using Raincode IMSql. It's more complex to migrate an IMS Database (DB) application to a cloud-native solution than to migrate a relational database application. This article describes how to rehost a mainframe IMS workload that has critical IMS features and capabilities to Azure. You don't need to translate or modify your existing application.

## Premigration IMS DB and IMS Data Communications workload architecture

:::image type="complex" source="media/premigration-ims-database-data-communication.svg" alt-text="Diagram that shows the premigration IMS DB and data communications workload architecture." lightbox="media/premigration-ims-database-data-communication.svg" border="false":::
   Diagram that shows an Information Management System (IMS) Database (DB) and IMS Data Communications (DC) workload architecture before migration to Azure. An on-premises user accesses communication protocols like HTTPS via a TN3270 terminal or a web interface. A bidirectional arrow connects the communication protocols to transaction managers like IMS Data Communications (DC). The front end contains online programs and is associated with the transaction managers. A bidirectional arrow labeled DL/I connects the front end to the back end. The back end contains IMS data and is associated with the data layer. This box contains IMS data and it connects to the IMS Database (DB) data layer. A bidirectional arrow labeled DL/I connects the data layer to a box that contains job control language (JCL) batch jobs. The other services box contains services like security and reporting. These services interact with all the parts of the diagram. 
:::image-end:::

### Data flow

The following data flow corresponds to the previous diagram:

1. Users connect to the mainframe over TCP/IP by using standard mainframe protocols like TN3270 and HTTPS.

1. Transaction managers interact with users and invoke the application to satisfy user requests.

1. Users interact with IMS screens or webpages in the application layer front end.

1. Application code uses the hierarchical IMS DB back-end data layer's storage capabilities.

1. Batch jobs perform offline big data operations.

1. Along with transaction processing, other services provide authentication, security, management, monitoring, and reporting. These services interact with other system services.

## IMSql architecture on Azure

:::image type="complex" source="media/rehost-ims-raincode-imsql.svg" alt-text="Diagram that shows the IMSql architecture on Azure." lightbox="media/rehost-ims-raincode-imsql.svg" border="false":::
   Diagram that shows the IMSql architecture on Azure. On the left, an on-premises 3270 terminal emulator connects on-premises users to Azure ExpressRoute, which bridges the on-premises environment with Azure. The right side, labeled Azure, contains multiple components and services connected by arrows. Azure system users access the IMSql terminal server through an Azure Logic Apps, IBM 3270 terminal interface. A bidirectional arrow labeled service broker connects the user terminals and the application programs. Arrows connect Virtual Machine Scale Sets to Information Management System (IMS) application data in the SQL Managed Instance box. This box connects to Microsoft services like Azure Functions and Microsoft Fabric, which read and write IMS data. Virtual Machine Scale Sets, IMS application data, Microsoft services, the service broker, and the IMSql terminal server are in a box labeled Microsoft Entra ID.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/rehost-ims-raincode-imsql.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. IMSql terminal server

   Traditionally, on-premises users access the mainframe z/OS interface by using an IBM in-house terminal or by using terminal emulation software. An application that has a geographically dispersed network with thousands of users connects to the mainframe by using a terminal. If you rehost an IMS Data Communications (DC) application on a distributed cloud-based system, you need to centrally host the application and the resource and publish them for the remote client devices. To host and publish the application and the resource on Azure, use IMSql terminal servers.

1. SQL Server service broker

   In the mainframe, IMS DC transmits and processes messages in a control region to orchestrate the communication layer between user terminals and application programs. After the rehost, the SQL Server service broker orchestrates this asynchronous communication layer. This service broker supports communication through its message delivery framework and scales out messages to separate processing servers, current users, and their transaction processing.

1. IMSql processing server

   The processing server runs Raincode-recompiled code for IMS programs in .NET Framework or .NET. The server contains the underlying infrastructure so that recompiled programs run effectively and with correct functional equivalence. The IMSql processing server can generate dynamic queries and call stored procedures in SQL Server that are created during Data Language/One (DL/I) call recompilation.

1. SQL Server as a hierarchical data store

   Data is stored hierarchically in IMS. IMSql uses the same model on SQL Server. This model uses high performance relational databases to logically implement hierarchical segments from IMS. The model supports independent scaling with segments. Segment data is stored in raw EBCDIC format so that it doesn't require conversion for the application. By using SQL platform as a service (PaaS), IMSql can take advantage of the underlying high availability and disaster recovery capabilities that Azure provides.

1. DL/I call API

   The IMSql API translates COBOL IMS DL/I calls to equivalent SQL queries. The API fetches data and returns it to the application program in the expected format. IMSql tracks the program position on the table record to perform create, read, update, and delete operations like the hierarchical database. To respond to performance-intensive DL/I calls, IMSql can create stored procedures in SQL Server during compilation.

1. Raincode JCL

   Raincode job control language (JCL) is a z/OS JCL-compatible interpreter. Raincode JCL smooths the transition from the intricate business logic embedded in JCL to Azure and .NET platforms. Raincode JCL runs code compiled by Raincode COBOL, PL/I, and ASM370 compilers. Raincode JCL runs steps written in most languages. Implement user-written code to configure and adapt it for bespoke batch scheduling.

1. IMSql data view

   IMSql defines relational SQL views based on copybooks or record layouts so Azure services and new applications can access IMS segments by using plain SQL statements. IMSql views are writable, so modern applications can both read and write to IMS via SQL Server.

## Data migration via IMSql

:::image type="complex" source="media/data-migration-imsql.svg" alt-text="Diagram that shows the data migration via IMSql." lightbox="media/data-migration-imsql.svg" border="false":::
   Diagram that shows the data migration process via IMSql. The diagram is divided into two sections, on-premises and Azure. A dotted, bidirectional arrow that represents Azure ExpressRoute connects the two sections. In the on-premises section, the data store box contains nonrelational databases and database description (DBD) files. An arrow labeled IBM utility points from the nonrelational databases to the DBD and data files. An arrow from the DBD and data files passes through an icon for self-hosted integration runtime and to a box in the Azure section that contains Azure Data Factory and FTP. An arrow points from this box to Azure Blob Storage. Another arrow points from Blob Storage to a box that contains the IMSql processing server. This box contains database object conversion and data load. Arrows point from these boxes to another box in which a dotted line connects icons for SQL Managed Instance, an application database, and read-write views on IMS data.
:::image-end:::

### Database object migration

- IMSql extracts and transfers the original IMS database description (DBD) from the mainframe. IMSql uses DBD information to produce SQL scripts to generate a target database and tables in Azure SQL.

- Each segment in an IMS DBD is translated as a table in Azure.

- Tables include a key field, search fields, and IMS segment data represented in EBCDIC.

- Azure SQL tables retain the IMS segment tree structure and the primary and foreign key relationships.

### Initial data load

- Data from the IMS DB is extracted via a mainframe job and download utilities like DFSRRC00 and DFSURGL0.

- You can transfer extracted binary files to Azure by using Azure Data Factory connectors, like FTP and Secure FTP (SFTP), and a Java-based solution that runs on Unix Subsystem Services.

- IMSql has a built-in load utility for completing the initial data loads. This tool uses the SQL Server bulk copy program (bcp) utility. The tool ensures that bcp runs and checks that the referential integrity between the tables matches the expected hierarchical structure.

- This migration addresses a one-time data load from the IMS DB, but it doesn't address coexistence and associated data synchronization.

### Data flow

The following data flow corresponds to the previous diagram:

1. IMS DB contains the DBD and the segment data.

1. IBM utilities extract and unload IMS DB information.

1. The DBD file and corresponding binary data files are generated separately.

1. The following steps describe the data ingestion process:

   1. The Azure Data Factory FTP connector copies mainframe IMS datasets to Azure data storage.

   1. Mainframe IMS data files are copied to Azure Blob Storage via SFTP.

   1. Mainframe JCL runs a custom Java solution that moves data between the mainframe system and the SFTP Blob Storage.

1. IMSql creates the target database and tables, and maintains referential integrity, by using the DBD file.

1. IMSql loads the created data objects to the corresponding tables in sequential order.

1. Azure SQL Managed Instance hosts migrated IMS data.

1. The application database contains the raw segment data that's used for online IMS processing and batch processing.

1. The IMS read and write views contain segment data that expands based on the copybook layout.

### Migrate IMS DB data by using Raincode zBridge

[Raincode zBridge](https://www.raincode.com/zbridge/) facilitates access to mainframe nonrelational data on Azure, including data from IMS DB segments. You can access this data in Azure SQL databases for distributed applications and for reporting and analytical purposes.

Import IMS segment data files into zBridge by using a matching COBOL copybook or PL/I include. The data appears as SQL rows that convert mainframe numeric types to SQL types and that convert strings to ASCII if needed. zBridge also supports complex data structures.

### Components

- [Azure Logic Apps](/azure/logic-apps/logic-apps-overview) is a cloud platform for powerful integration solutions. Mainframe users familiar with 3270 terminals and on-premises connectivity can use the Logic Apps [IBM 3270 connector](/azure/connectors/integrate-3270-apps-ibm-mainframe) to access and run IBM mainframe apps. In this architecture, Logic Apps supports mainframe interaction with migrated Azure applications by using either the public internet or an Azure ExpressRoute private connection that uses Microsoft Entra ID for authentication.

- [Azure Virtual Machine Scale Sets](/azure/well-architected/service-guides/virtual-machines) is a compute service that provides automated and load balanced virtual machine (VM) scaling that simplifies application management and increases availability. In this architecture, Virtual Machine Scale Sets provides enough VMs for the IMSql workload's mission-critical online and batch processing needs.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) supports secure communication between Azure resources, like Azure VMs, and with the internet and on-premises networks. Virtual Network is like a traditional network that you operate in your own datacenter, but it provides the scale, availability, and isolation of Azure infrastructure. In this architecture, Virtual Network provides a secure network foundation for effective communication between IMSql components.

- [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) is a connectivity service that extends your on-premises networks into the Microsoft Cloud over a private connection facilitated by a connectivity provider. You can use ExpressRoute to establish connections to Microsoft Cloud services like Azure and Microsoft 365. In this architecture, ExpressRoute provides secure, high-bandwidth connectivity between on-premises mainframe environments and the migrated IMS applications that run on Azure.

- [Microsoft Entra ID](/entra/fundamentals/what-is-entra) is a cloud-based enterprise identity and access management service. In this architecture, Microsoft Entra ID protects against cybersecurity attacks and provides single sign-on and multifactor authentication to help users sign in and access resources.

- [SQL Managed Instance](/azure/well-architected/service-guides/azure-sql-managed-instance) provides a fully managed SQL Server instance in Azure. In this architecture, SQL Managed Instance provides the relational database platform for converted hierarchical IMS DB data structures with high availability and Azure service integration.

### Alternatives

- You can use SQL Server in an Azure VM instead of SQL Managed Instance. We recommend SQL Managed Instance because of its high availability, integration with Azure services, and management of security patches and maintenance.

- You can use an Azure single-VM architecture instead of Virtual Machine Scale Sets. Consider single VMs for workloads that have constant load and performance demands and don't require scaling. This architecture uses Virtual Machine Scale Sets to handle typical IMS workloads.

## Scenario details

Mainframe online transaction processing (OLTP) systems can process millions of transactions for many users. IBM IMS is a classic mainframe transaction manager for OLTP. IBM IMS comprises IMS DC, the transaction manager, and IMS DB, the underlying hierarchical database management system (DBMS).

IMSql provides IMS-based workload hosting on Azure and on-premises, SQL Server-based, distributed implementations. IMSql provides a holistic solution for IMS workloads, including the app, data, and middleware components. IMSql can ingest hierarchical IMS DB data structures to a relational data model in SQL Server, SQL Server on Azure Virtual Machines, and SQL Managed Instance. It has built-in APIs for IMS application program DL/I calls, and it extends the data layer beyond hierarchical workloads to cloud-native apps for relational data.

This solution:

- Modernizes infrastructure and reduces the high costs, limitations, and inflexibility of monolithic mainframe IMS workloads.

- Implements cloud-native solutions and DevOps to reduce technical debt.

- Sends IMS DB data to cloud-based applications that don't use mainframes, including AI and analytics applications.

### Potential use cases

This solution might be useful for:

- Banking, finance, insurance, government, and retail industries that use Mainframe IMS. Many of these organizations run their primary OLTP and batch applications on IMS DB and IMS DC.

- IBM zSeries mainframe customers who need to migrate business-critical applications. These customers often want to maintain continuity with other on-premises applications and to avoid the effects of a complete redevelopment.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Nithish Aruldoss](https://www.linkedin.com/in/nithish-aruldoss-b4035b2b) | Engineering Architect
- [Amethyst Solomon](https://www.linkedin.com/in/amethyst-solomon) | Senior Engineering Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Copy files from the mainframe to Azure Data Factory by using the FTP connector](https://techcommunity.microsoft.com/blog/modernizationbestpracticesblog/copy-files-from-mainframe-to-azure-data-platform-using-adf-ftp-connector/3042555) 
- [Transfer mainframe files to Blob Storage by using SFTP](https://techcommunity.microsoft.com/blog/modernizationbestpracticesblog/mainframe-files-transfer-to-azure-data-platform-using-sftp/3302194)
- [What is Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [What is ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [Microsoft Fabric documentation](/fabric)

## Related resources

- [General mainframe refactor to Azure](./general-mainframe-refactor.yml)
- [Re-engineer mainframe batch applications on Azure](./reengineer-mainframe-batch-apps-azure.yml)