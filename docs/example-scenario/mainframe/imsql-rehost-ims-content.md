This architecture shows how to use Raincode's IMSql to rehost IMS Database Manager (IMS DB) and IMS Transaction Manager (MS TM) systems on .NET and SQL Server in the simplest way: by using virtual machines. You can recompile legacy applications to target .NET and interact with IMSql in the same way that they interact with IMS on a mainframe. IMSql transitions mainframe applications to an Azure-native architecture while thoroughly preserving the business logic. 

Architecture

Source (or Before) IBM z/OS Architecture 

image

download link ??

Mapping Annotations from Source IBM z/OS to Azure  

1. Input occurs over TCP/IP, including TN3270 and HTTP(S).   

1. Input into the mainframe uses standard mainframe communication protocols.  

1. Receiving applications can be either batch or online systems.  

1. COBOL, PL/I, Assembler, or other compatible languages run in an enabled environment.  

1. Data and database services commonly used are hierarchical/network database systems and relational database types.  

1. Common services include program execution, I/O operations, error detection, and protection within the environment.  

1. Middleware and utilities manage services like tape storage, queueing, output, and web services within the environment.  

1. Operating systems provide the interface between the engine and the software that it runs.  

1. Partitions are needed to run separate workloads and to segregate work types within the environment.  

Azure (Target or After Migration) Architecture  

image 

download link 

Workflow

1. IBM 3270 terminal emulators can connect to IMS/TM applications deployed on Azure as-is through the Raincode IMSql Terminal Server. 
1. Batch processes written in JCL can be executed as is through transient Azure Container Instances running the Raincode JCL interpreter. 
1. Read-write SQL Server views on the IMS data enable modern applications or business intelligence (e.g. Microsoft Power BI) to communicate directly with IMS applications, abstracting away the mainframe aspects such as data structures and character encodings. 
1. The Raincode Console provide a web-based administration environment for IMSql. 
1. SQL Server Service Broker is used as the communications backbone for IMSql components.

### Components

- [Azure Virtual Networks]() - Azure Virtual Network (VNet) is the fundamental building block for your private network in Azure. VNet enables many types of Azure resources, such as Azure Virtual Machines (VM), to securely communicate with each other, the internet, and on-premises networks. VNet is similar to a traditional network that you'd operate in your own data center but brings with it additional benefits of Azure's infrastructure such as scale, availability, and isolation.  
- [Azure Virtual Machine Scale Sets](https://azure.microsoft.com/services/virtual-machine-scale-sets) is automated and load balanced VM scaling that simplifies management of your applications and increases availability. 
- [Azure SQL Managed Instance](https://azure.microsoft.com/services/azure-sql/sql-managed-instance), part of the Azure SQL service portfolio, is a managed, secure, and always up-to-date SQL instance in the cloud.

### Alternatives

- A classic alternative for Azure SQL MI is Azure SQL server IaaS. Azure SQL MI is preferred in this architecture because of benefits like High Availability (HA), seamless integration to various Azure services and SQL MI cover underlying security patches and maintenance.  

- Azure VM scale set could be replaced with Azure single VM architecture. Azure VM could be adapted for workload with constant load and performance demands and no need for scaling, in this architecture we use Azure VM scale set to handle typical IMS workloads.

## Scenario details

This architecture shows how to seamlessly rehost to Azure a mainframe workload that has critical IMS features and capabilities. You don't need to translate or modify your existing application. The architecture uses IMSql and Azure SQL.

- Raincode’s Compilers generate 100% thread-safe and managed code for .NET 
- IMSql is intrinsically non-transformational: it keeps the sources (COBOL, PL/I) as-is with the IMS-specific CBLTDLI and PLITDLI calls, as well as EXEC DLI statements unaltered. This ensures optimal maintainability of the resulting system. This property extends to IMS/DB data: it is imported as is, in bulk, with no change whatsoever, cleansing or normalization. 
- IMSql leverages SQL Server as a database, transaction processor, and execution platform, leveraging the effort that has been put into making this platform robust, versatile and scalable. 
- IMSql operates in three modes:  
   - Online 
   - Batch 
   - Load and Unload (for data migration or for JCLs that produce and/or consume sequential files) 
- On mainframes, DBDs (Database Description) and PSBs (Program Specification Block) are compiled to create the database and the program’s description. Similarly, on IMSql, DBDs and PSBs are compiled into an XML representation. This enables IMS-aware programs to determine which database segments pertain to them, and drives the generation of the various server-side artefacts for IMSql (database schema, stored procedures, etc.) 

### Potential use cases  

Many scenarios can benefit from Raincode’s IMSql, including:  
- Businesses seeking to modernize infrastructure and escape the high costs, limitations, and rigidity associated with IMS, or more generally, the mainframe where it runs  
- Reduce Technical Debt by going Cloud Native and supporting a DevOps strategy.  
- Organizations opting to move IMS workloads to the cloud without the side effects of a complete redevelopment. 
- IMS mission-critical applications which needs to move while maintaining continuity with other on-premises applications. 

## Considerations 

### Reliability

- This OLTP architecture can be deployed in multiple regions and can have a geo replication data layer. 
- The Azure database services support zone redundancy and can fail over to a secondary node in the event of an outage, or to allow for maintenance activities.

### Security

This solution uses an Azure network security group to manage traffic to and from Azure resources. For more information, see [Network security groups](/azure/virtual-network/network-security-groups-overview). 

The security options in Azure database services are: 

- Data encryption at rest. 
- Dynamic data masking. 
- Always-encrypted database. 

For general guidance on designing secure SQL solutions, see [Azure security recommendation]().

### Cost optimization 

- Azure provides cost optimization by running on Windows VMs which allow the ability to turn off the VMs when not in use and scripting a schedule for known usage patterns. Azure focuses on avoiding unnecessary costs by identifying the right number or resource types, analyzing spending overtime and scaling to meet business needs without overspending.  
- Azure SQL MI provides different pricing tiers like General Purpose (GP) and Business Critical (BC) to optimize cost based on usage and business criticality.  
- Azure Reserved Instances with pay-as-you-go prices to manage costs across predictable and variable workloads. In many cases, you can further reduce your costs with reserved instance size flexibility. 

Use [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator) to estimate the cost of implementing the solution.

## Contributors 

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:  Bhaskar Bandam 

Other contributors: Mick Alberts

## Next steps 

- For more information, please contact [legacy2azure@microsoft.com](mailto:legacy2azure@microsoft.com) 
- IMSql Technical User Guide [IMSql User Guide (raincode.com)](https://www.raincode.com/docs/IMSql/UserGuide/UserGuide.html#_imsql_user_guide)
- IMSql installation Guide [Installation Guide (raincode.com)](https://www.raincode.com/docs/IMSql/InstallationGuide/InstallationUserGuide.html#Installation-of-IMSql) 

## Related resources

- [Rehost IMS/DC(TM) and IMS/DB to Azure using Raincode IMSql under Data Modernization] 