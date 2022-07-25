Mainframe OLTP systems can process millions of transactions for vast numbers of users. IBM Information Management System (IMS) is one a robust classic mainframe transaction manager used by major companies for online transaction processing. It has two main components, the IMS/DC (Data Communications) component and the underlying hierarchical DBMS IMS DB (database) component.

This architecture describes how to implement an IMS mainframe application workload to Azure by using Raincode's IMSql. Migrating an IMS DB application to a cloud-native solution is more complex than migrating a relational database application. In this article, we discuss rehosting a mainframe IMS workload to Azure seamlessly, without translating or modifying of an existing application with critical IMS features and capabilities. The solution uses IMSql and Azure SQL.

IMS DB/DC workload architecture

image 

1. Users connect to the mainframe over TCP/IP using standard mainframe protocols like TN3270 and HTTPS. 
1. The transaction managers interact with the users and invoke the application to satisfy user requests. 
1. In the front end of the application layer, users interact with the IMS screens or with web pages. 
1. Application code uses storage capabilities of IMS DB (hierarchical) back-end data layer. 
1. All offline huge data operations are performed through batch jobs.   
1. Concurrently with transaction processing, other services provide authentication, security, management, monitoring, and reporting. These services interact with all other services in the system.

IMSql Overview 

Raincode’s IMSql product provides a way forward for IMS based workloads to be hosted on Azure or on-prem distributed SQL Server based implementations. The product provides a holistic solution to run an IMS workload – including the app, data, and middleware components. IMSql has the capability and features to ingest the hierarchical (IMS DB) data structure to relational Data Model in SQL Server, SQL on VM and Azure SQL MI. It has built-in APIs (Application Programming Interfaces) for IMS application programs D/LI calls and extends the data layer beyond the hierarchical workload to cloud native apps that are used to relational data. We will be looking at the components and technologies used in this product and how they operate together 

IMSql Architecture on Azure 

image 

Workflow 

1. IMSql Terminal Server 

 

The traditional way to access the Mainframe z/OS interface is through an IBM in-house terminal or terminal emulation software. Any application with a geographically dispersed network with thousands of users can connect to the Mainframes through any form of terminal. When an IMS DC application is rehosted on the distributed cloud-based system there is a need to centrally host the application and resource and publish them for the remote client devices. The IMSql Terminal Servers enable business to accomplish this on Azure. 

 

2. SQL Server Service broker 

 

In Mainframe IMS DC orchestrates the communication layer between the user Terminals and the application programs by transmitting and processing messages in a control region. This asynchronous communication layer is orchestrated using SQL Server’s Service Broker functionality on rehosting. The service broker helps with communication through its message delivery framework, scales out messages to separate processing servers, current Users, and their diversified transaction processing.      

 

3. IMSql Processing Server 

 

The Processing Server executes the Raincode recompiled code for the IMS programs in .NET Framework or .NET Core. The Processing Server contains the necessary underlying infrastructure needed for the recompiled programs to execute effectively with the correct functional equivalence. IMSql’s Processing Server can generate dynamic queries and can call SQL Stored Procedures that were created during the recompilation of DL/I calls.     

 

4. SQL Server as a Hierarchical Data Store 

 

Data is stored in a hierarchical nature in IMS, and IMSql implements the same on SQL Server. This allows IMSql to utilize the performance to a relational database and logically implement the hierarchical segments from IMS. This also allows the system to scale independently with segments. The segment data is stored in raw EBCDIC format and therefore needs no conversion for the application. By utilizing SQL PaaS, the IMSql product can utilize the underlying HA/DR capabilities that comes with Azure Platform. 

5. DL/I call API  

- IMSql API ensures the Cobol IMS DL/I calls are translated to equivalent SQL queries, fetches, and returns the data back to the application program in the expected format. 
- IMSql also tracks the Program position on the Table record to perform CRUD operations like the hierarchical DB.   
- IMSql has the capability to create SQL stored procedures during compilation to address performance intensive DL/I Calls. 

6. Raincode JCL 

Raincode JCL is an interpreter compatible with z/OS JCL. The Raincode JCL interpreter makes the transition of the intricate business logic embedded into JCL to Azure and .NET Core platforms as smooth and painless as possible. Raincode JCL is designed to run code that has been compiled by the Raincode COBOL, PL/I and ASM370 compilers and it can easily run steps written in virtually any language. It has the facility to be configured and fine-tuned with user-written code, so it can be easily adapted to your own needs for batch scheduling. 

7. IMSql Data View  

- IMSql defines relational SQL views based on copybooks (record layouts), so that the IMS segments can be accessed with plain SQL statements by any Azure service and new applications.    
- IMSql views are also writable, enabling modern applications to interact with IMS both ways through SQL Server. 

Components 

[Azure Logic Apps (IBM 3270 Connector)]() Mainframe users are familiar with 3270 terminals and on-premises connectivity. In the migrated system, they interact with Azure applications via public internet or via a private connection implemented with Azure ExpressRoute. Azure Active Directory (Azure AD) provides authentication. 

[Azure Virtual Network (VNet)]() is the fundamental building block for your private network in Azure. VNet enables many types of Azure resources, such as Azure Virtual Machines (VM), to securely communicate with each other, the internet, and on-premises networks. VNet is like a traditional network that you'd operate in your own datacenter, but it brings more benefits of Azure's infrastructure, such as scale, availability, and isolation.  

[Azure ExpressRoute]() lets you extend your on-premises networks into the Microsoft cloud over a private connection facilitated by a connectivity provider. With ExpressRoute you can establish connections to Microsoft cloud services, such as Microsoft Azure and Office 365. 

[Azure Virtual Machine Scale Sets]() is automated and load balanced VM scaling that simplifies management of your applications and increases availability. 

[Azure SQL Managed Instance](), part of the Azure SQL service portfolio, is a managed, secure, and always up-to-date SQL instance in the cloud. 

[Azure AD]() is Microsoft's cloud-based enterprise identity and access management service. Azure AD single sign-on and multifactor authentication help users sign in and access resources, while protecting from cybersecurity attacks. 

Data Migration using IMSql 

Database Object Migration

- The original IMS DB DBD is extracted and transferred from Mainframe. Using this DBD details, the IMSql produces the SQL scripts for generating Target Database and tables in Azure SQL.    
- Each Segment in an IMS DBD is translated as a table in Azure. 
- The tables consist of Key Field, Search Fields, and the Complete IMS segment data ‘as is’ in EBCDIC. 
- IMS Segment tree structure is retained with the Primary and Foreign key relationship in Azure SQL tables.

Initial Data Load   

- The data from IMS DB is extracted using mainframe job using commonly available download utilities like DFSRRC00, DFSURGL0.  
- The extracted binary files can be transferred to Azure using Data Factory connectors like FTP, sFTP and Java based solution which runs on USS (Unix Subsystem Services).  
- IMSql has an inbuilt load utility to perform the initial data loads. This tool uses the SQL Server bcp (bulk copy program) utility under the covers. It ensures bcp execution and the required referential integrity between the tables to match the expected hierarchical structure. 
- This migration focuses on one time data load from IMS DB and not the co-existence and associated data synchronization.  

 image 

Data Flow 

1. Mainframe non-Relational datastore (IMS DB) data objects and data. It has two components, the DBD (Database Definition) and the actual segments data. 
1. IBM utilities are used to extract and unload the IMS DB related information. 
1. The DBD File and corresponding binary data files are generated separately. 
1. Data ingestion  
   1. Azure Data Factory FTP connector to copy Mainframe IMS datasets to Azure Data storage.   
   1. Copy Mainframe IMS data files to Azure Blob storage using sFTP. 
   1. Mainframe JCL to run a custom Java solution to move data between the mainframe system and sFTP Azure Blob Storage.  
1. Using the DBD file the Raincode IMSql creates the Target DB and Tables with necessary referential integrity. 
1. After successful data object creation IMSql loads the data to the corresponding table in a sequential order. 
1. All IMS Data migrated is hosted in Azure SQL MI. 
1. The application database consists of the raw segment data for processing IMS on-line and batch processing. 
1. The IMS Read-Write views consist of segment data expanded based on the copybook layout.

Alternatives

1. A classic alternative for Azure SQL MI is Azure SQL server IaaS. Azure SQL MI is preferred in this architecture because of benefits like High Availability (HA), seamless integration to various Azure services and SQL MI cover underlying security patches and maintenance.  
1. Azure VM scale set could be replaced with Azure single VM architecture. Azure VM could be adapted for workload with constant load and performance demands and no need for scaling, in this architecture we use Azure VM scale set to handle typical IMS workloads.

Scenario Details 

- Migrate IMS DC/DB workload to cloud native components and Technology. 
- Businesses seek to modernize infrastructure and reduce the high costs, limitations, and rigidity associated with monolithic mainframes IMS workloads. 
- Reducing Technical Debt by going cloud native and DevOps. 
- Exhibit IMS DB data to non-mainframe and cloud-based applications, including AI and analytics. 
- IBM zSeries mainframe customers who need to migrate mission-critical applications while maintaining continuity with other on-premises applications. 

Potential Use Case for IMSql

- Banking, Finance, Insurance, Government, and Retail industries are widely known using Mainframe IMS. Most of them run their premier OLTP and batch applications on IMS DB/DC.  
- Organizations opting to move IBM zSeries mainframe workloads to the cloud without the side effects of a complete redevelopment. 

Considerations 

The following considerations, based on the [Azure Well-Architected Framework](/azure/architecture/framework/index), apply to this solution.

Reliability 

- This OLTP architecture can be deployed in multiple regions and can have a geo replication data layer. 
- The Azure database services support zone redundancy and can fail over to a secondary node in the event of an outage, or to allow for maintenance activities. 

Security 

- ExpressRoute provides a private and efficient connection to Azure from on-premises. 
- Azure resources can be authenticated by using Azure AD. Permissions can be managed by role-based access control (RBAC). 
- This solution uses an Azure network security group to manage traffic to and from Azure resources. For more information, see [Network security groups](/azure/virtual-network/network-security-groups-overview). 
- The security options in Azure database services are: 
   - Data encryption at rest. 
   - Dynamic data masking. 
   - Always-encrypted database. 
   - For general guidance on designing secure data solutions, see [Azure security recommendation](/sql/relational-databases/security/security-center-for-sql-server-database-engine-and-azure-sql-database?view=sql-server-ver16). 

Cost optimization  

- Azure Virtual Machine scale sets Optimize costs by minimizing the number of unnecessary hardware instances that run your application when demand is low. 
- Azure SQL MI provides different pricing tiers like General Purpose (GP) and Business Critical (BC) to optimize cost based on usage and business criticality.  
- Azure Reserved Instances with pay-as-you-go prices to manage costs across predictable and variable workloads. In many cases, you can further reduce your costs with reserved instance size flexibility. 
- Azure Hybrid Benefit is a licensing benefit that helps you to significantly reduce the costs of running your workloads in the cloud. It works by letting you use your on-premises Software Assurance-enabled Windows Server and SQL Server licenses on Azure. 

Use [Azure Pricing Calculator](https://azure.com/e/f5d10c617bfa410cb7566ee7f30a8e2f" HYPERLINK "https://azure.microsoft.com/en-us/pricing/calculator) to estimate the cost of implementing the solution.  

Performance efficiency 

- VM Scale sets ensure that enough VMs are available to meet mission-critical online and batch process needs. 
- Blob Storage is a scalable system for storing backups, archival data, secondary data files, and other unstructured digital objects. 
- The [Microsoft Database Engine Tuning Advisor (DTA)](/sql/relational-databases/performance/database-engine-tuning-advisor?view=sql-server-ver16) analyzes databases and makes recommendations that you can use to optimize query performance. You can use the Database Engine Tuning Advisor to select and create an optimal set of indexes, indexed views, or table partitions 
- [Scalability](/azure/azure-sql/database/scale-resources?view=azuresql) is one of the most important characteristics of platform as a service (PaaS) that enables you to dynamically add more resources to your service when needed. Azure SQL Database enables you to easily change resources (CPU power, memory, IO throughput, and storage) allocated to your databases. SQL Managed Instance enables you to dynamically add more resources to your database with minimal downtime 
- [In-Memory OLTP](/sql/relational-databases/in-memory-oltp/overview-and-usage-scenarios?view=sql-server-ver16) is the premier technology available in SQL Server and SQL Database for optimizing performance of transaction processing, data ingestion, data load, and transient data scenarios.  

Contributors 

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal authors: 

Other contributors: 

## Next steps 

- [Mainframe to Azure Data Factory using FTP Connector](https://techcommunity.microsoft.com/t5/modernization-best-practices-and/copy-files-from-mainframe-to-azure-data-platform-using-adf-ftp/ba-p/3042555) 
- [Mainframe to Azure Data Platform using sFTP](https://techcommunity.microsoft.com/t5/modernization-best-practices-and/mainframe-files-transfer-to-azure-data-platform-using-sftp/ba-p/3302194)
- For more information, contact [Mainframe Modernization](mailto:mainframedatamod@microsoft.com) 
